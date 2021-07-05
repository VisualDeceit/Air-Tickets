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

@end

@implementation SearchResultViewController {
    BOOL isFavorites;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        isFavorites = NO;
        _tickets = tickets;
        self.title = @"Tickets";
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
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
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
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"From Search", @"From Price Map"]];
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

@end
