//
//  SearchResultViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *optionsBarItem;
@property (nonatomic) FavoriteSortType favoriteSortType;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;

@end

@implementation SearchResultViewController {
    BOOL isFavorites;
    SearchTicketTableViewCell *notificationCell;

}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        isFavorites = NO;
        _tickets = tickets;
        self.title = @"Tickets";
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        [_datePicker setPreferredDatePickerStyle: UIDatePickerStyleWheels];
        
        _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTap)];
        keyboardToolbar.items = @[doneBarButton, flexBarButton, cancelBarButton];

        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview:_dateTextField];
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
    }
    return self;
}

- (instancetype)initForFavoriteTickets {
    self = [super init];
    if (self)
    {
        isFavorites = YES;
        _favoriteSortType = FavoriteSortTypeAscPrice;
        _tickets = [NSArray new];
        self.title = @"Favorites";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (isFavorites) {
        [self changeSource];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SearchTicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        if ([[CoreDataHelper sharedInstance] isFavorite:[_tickets objectAtIndex:indexPath.row]]) {
            cell.showFavoriteSign = YES;
        } else {
            cell.showFavoriteSign = NO;
        }
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Action with ticket" message:@"What should be done with the selected ticket?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite:[_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Remove from favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
            [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Add to favourites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row] from:FavoriteSourceSearch];
            [self.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:NO];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Set reminder" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self->_dateTextField becomeFirstResponder];
    }];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//MARK: - Private
- (void)configureUI {
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[SearchTicketTableViewCell class] forCellReuseIdentifier:SearchTicketCellReuseIdentifier];
    [self.view addSubview:_tableView];
    
    //для избранного
    if (isFavorites) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Search", @"Price Map"]];
        [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.tintColor = [UIColor blackColor];
        self.navigationItem.titleView = _segmentedControl;
        _segmentedControl.selectedSegmentIndex = 0;
        [self changeSource];
        //меню сортировки
        _optionsBarItem = [[UIBarButtonItem alloc] init];
        _optionsBarItem.menu = [self generateSortMenu];
        _optionsBarItem.image = [UIImage systemImageNamed:@"arrow.up.arrow.down"];
        _optionsBarItem.tintColor = [UIColor labelColor];
        self.navigationItem.rightBarButtonItem = _optionsBarItem;
    }
}

//генерация меню сортировки
- (UIMenu *)generateSortMenu {
    UIImage *priceImage;
    UIImage *dateImage;
    UIImage *sourceImage  = [UIImage imageNamed:@"descending-sort.png"];
    //установка стрелки напрвления
    switch (self->_favoriteSortType) {
        case FavoriteSortTypeAscPrice:
            priceImage = sourceImage;
            dateImage = nil;
            break;
        case FavoriteSortTypeAscDate:
            priceImage = nil;
            dateImage = sourceImage;
            break;
        case FavoriteSortTypeDescPrice:
            priceImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                             scale:sourceImage.scale
                                       orientation:UIImageOrientationDown];
            dateImage = nil;
            break;
        case FavoriteSortTypeDescDate:
            priceImage = nil;
            dateImage = [UIImage imageWithCGImage:sourceImage.CGImage
                                            scale:sourceImage.scale
                                      orientation:UIImageOrientationDown];
            break;
    }
    
    //сортировка
    void (^menuHandler)(UIAction *) = ^(__kindof UIAction * _Nonnull action){
        if ([action.identifier  isEqual: SORT_BY_PRICE]) {
            if (self->_favoriteSortType == FavoriteSortTypeDescPrice)
                self->_favoriteSortType = FavoriteSortTypeAscPrice;
            else
                self->_favoriteSortType = FavoriteSortTypeDescPrice;
            
        }
        else if ([action.identifier  isEqual: SORT_BY_DATE]) {
                if (self->_favoriteSortType == FavoriteSortTypeDescDate)
                    self->_favoriteSortType = FavoriteSortTypeAscDate;
                else
                    self->_favoriteSortType = FavoriteSortTypeDescDate;
            }
        [self changeSource];
        self->_optionsBarItem.menu = [self generateSortMenu];
    };
    
    return [UIMenu menuWithChildren:@[
        [UIAction actionWithTitle:@"Price" image:priceImage identifier:SORT_BY_PRICE handler:menuHandler],
        [UIAction actionWithTitle:@"Date" image:dateImage identifier:SORT_BY_DATE handler:menuHandler ],
    ]];
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _tickets = [[CoreDataHelper sharedInstance] favorites:FavoriteSourceSearch sort:_favoriteSortType];
            break;
        case 1:
            _tickets = [[CoreDataHelper sharedInstance] favorites:FavoriteSourcePriceMap sort:_favoriteSortType];
            break;
        default:
            break;
    }
    [_tableView reloadData];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (_datePicker.date && notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", notificationCell.ticket.from, notificationCell.ticket.to, notificationCell.ticket.price];

        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];

            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = NotificationMake(@"Ticket reminder", message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat: @"dd MMMM yyyy HH:mm"];
        [dateFormat setLocale: [NSLocale localeWithLocaleIdentifier:@"EN_en"]];
        NSString *stringDate = [dateFormat stringFromDate:_datePicker.date];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Successfully" message:[NSString stringWithFormat:@"Notification will be sent - %@", stringDate] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        _datePicker.date = [NSDate date];
        notificationCell = nil;
        [self.view endEditing:YES];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)cancelButtonDidTap {
    notificationCell = nil;
    [self.view endEditing:YES];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    cell.contentView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.250 animations:^{
            cell.alpha = 1;
            cell.contentView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1);
        }];
    });
}

@end
