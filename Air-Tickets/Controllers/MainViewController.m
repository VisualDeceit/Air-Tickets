//
//  MainViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import "MainViewController.h"
#import "SceneDelegate.h"
#import "SearchResultViewController.h"
#import "PlaceViewController.h"
#import "APIManager.h"

#define X_PADDING 8.0
#define Y_PADDING 8.0
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SELECT_BUTTTON_WIDTH 100.0
#define TEXT_FIELD_WIDTH SCREEN_WIDTH - X_PADDING * 3.0 - SELECT_BUTTTON_WIDTH

@interface MainViewController ()

@property (nonatomic, strong) UILabel *departureLabel;
@property (nonatomic, strong) UITextField *departureTextField;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UILabel *destinationLabel;
@property (nonatomic, strong) UITextField *destinationTextField;
@property (nonatomic, strong) UIButton *destinationButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *mapPriceButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) LocationService *locationService;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    [DataManager.sharedInstance loadData];
}

- (void) configureUI {
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search tickets";

    CGRect departureLabelFrame = CGRectMake(X_PADDING, 114.0, SCREEN_WIDTH - X_PADDING, 25.0);
    self.departureLabel = [[UILabel alloc] initWithFrame: departureLabelFrame];
    self.departureLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    self.departureLabel.textColor = [UIColor labelColor];
    self.departureLabel.textAlignment = NSTextAlignmentLeft;
    self.departureLabel.text = @"Departure";
    [self.view addSubview: self.departureLabel];
    
    CGFloat offset = self.departureLabel.frame.origin.y + self.departureLabel.frame.size.height + Y_PADDING;
        
    CGRect departureFrame = CGRectMake(X_PADDING, offset, TEXT_FIELD_WIDTH, 44.0);
    self.departureTextField = [[UITextField alloc] initWithFrame:departureFrame];
    self.departureTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.departureTextField.placeholder = @"Enter airport or city name...";
    self.departureTextField.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
    [self.view addSubview: self.departureTextField];
    
    CGRect departureButtonFrame = CGRectMake(TEXT_FIELD_WIDTH + X_PADDING * 2.0, offset, SELECT_BUTTTON_WIDTH, 44.0);
    self.departureButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.departureButton setTitle:@"Select" forState:UIControlStateNormal];
    self.departureButton.backgroundColor = [UIColor systemGray2Color];
    self.departureButton.tintColor = [UIColor whiteColor];
    self.departureButton.frame = departureButtonFrame;
    self.departureButton.layer.cornerRadius = 5.0;
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.departureButton];
    
    offset = self.departureTextField.frame.origin.y + self.departureTextField.frame.size.height + Y_PADDING * 2.0;
    
    CGRect destinationLabelFrame = CGRectMake(X_PADDING, offset, SCREEN_WIDTH - X_PADDING, 25.0);
    self.destinationLabel = [[UILabel alloc] initWithFrame: destinationLabelFrame];
    self.destinationLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
    self.destinationLabel.textColor = [UIColor labelColor];
    self.destinationLabel.textAlignment = NSTextAlignmentLeft;
    self.destinationLabel.text = @"Destination";
    [self.view addSubview: self.destinationLabel];
    
    offset = self.destinationLabel.frame.origin.y + self.destinationLabel.frame.size.height + Y_PADDING;
    
    CGRect destinationFrame = CGRectMake(X_PADDING, offset, TEXT_FIELD_WIDTH, 44.0);
    self.destinationTextField = [[UITextField alloc] initWithFrame:destinationFrame];
    self.destinationTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.destinationTextField.placeholder = @"Enter airport or city name...";
    self.destinationTextField.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightLight];
    [self.view addSubview: self.destinationTextField];
    
    CGRect destinationButtonFrame = CGRectMake(TEXT_FIELD_WIDTH + X_PADDING * 2.0, offset, SELECT_BUTTTON_WIDTH, 44.0);
    self.destinationButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.destinationButton setTitle:@"Select" forState:UIControlStateNormal];
    self.destinationButton.backgroundColor = [UIColor systemGray2Color];
    self.destinationButton.tintColor = [UIColor whiteColor];
    self.destinationButton.frame = destinationButtonFrame;
    self.destinationButton.layer.cornerRadius = 5.0;
    [self.destinationButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.destinationButton];
    
    offset =  self.destinationTextField.frame.origin.y + self.destinationTextField.frame.size.height + Y_PADDING * 3.0;
    
    CGRect searchButtonFrame = CGRectMake(X_PADDING, offset, SCREEN_WIDTH - X_PADDING * 2.0, 44.0);
    _searchButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_searchButton setTitle:@"Search tickets" forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor systemGray2Color];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = searchButtonFrame;
    _searchButton.layer.cornerRadius = 5.0;
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
    
    offset =  _searchButton.frame.origin.y + _searchButton.frame.size.height + Y_PADDING;
    
    CGRect mapPriceButtonFrame = CGRectMake(X_PADDING, offset, SCREEN_WIDTH - X_PADDING * 2.0, 44.0);
    _mapPriceButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [_mapPriceButton setTitle:@"Show price map" forState:UIControlStateNormal];
    _mapPriceButton.backgroundColor = [UIColor systemGray2Color];
    _mapPriceButton.tintColor = [UIColor whiteColor];
    _mapPriceButton.frame = mapPriceButtonFrame;
    _mapPriceButton.layer.cornerRadius = 5.0;
    [_mapPriceButton addTarget:self action:@selector(mapPriceDidTap) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:_mapPriceButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
}

// Search tickets
- (void)searchButtonDidTap:(UIButton *)sender {
    if ((!_searchRequest.origin) || (!_searchRequest.destionation)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Enter all initial data for the request" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray * _Nonnull tickets) {
        if (tickets.count > 0) {
            SearchResultViewController *searchResultViewController = [[SearchResultViewController alloc] initWithTickets:tickets];
            searchResultViewController.title = @"Tickets";
            [self.navigationController pushViewController:searchResultViewController animated:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No tickets found for this direction" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc]initWithType:PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc]initWithType:PlaceTypeDestination];
    }
    placeViewController.delegate = self;
    //через блок
    placeViewController.onSelectPlace = ^(id  _Nonnull place, PlaceType placeType, DataSourceType dataType) {
        [self setPlace:place withType:placeType andDataType:dataType];
    };
    [self.navigationController pushViewController:placeViewController animated:YES];
}

- (void)mapPriceDidTap {
  //  MapPriceViewController *mapPriceViewController = [[MapPriceViewController alloc] initWithLocation:_currentLocation];
 //   [self.navigationController pushViewController:mapPriceViewController animated:YES];
}

- (void)dataLoadedSuccessfully {
    //определение текущего города по IP
//    [[APIManager shared] cityForCurrentIP:^(City * _Nonnull city) {
//        [self setPlace:city withType:PlaceTypeDeparture andDataType:DataSourceTypeCity];
//    }];
    //определение текущего города через LocationService
    _locationService = [[LocationService alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    if (currentLocation) {
        City *city = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (city) {
            [self setPlace:city withType:PlaceTypeDeparture andDataType:DataSourceTypeCity];
        }
    }
}

- (void)setPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        self->_searchRequest.origin = iata;
        [self->_departureTextField setText:title];
    } else {
        self->_searchRequest.destionation = iata;
        [self->_destinationTextField setText:title];
    }
}

// MARK:- PlaceViewControllecDelegate
- (void)selectPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
   // [self setPlace:place withType:placeType andDataType:dataType];
}

@end