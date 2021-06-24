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

@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [DataManager.sharedInstance loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.prefersLargeTitles = NO;    
}

- (void) setupView {
    [self.view setBackgroundColor:[UIColor systemBackgroundColor]];

    
    CGRect departureLabelFrame = CGRectMake(X_PADDING, 80.0, SCREEN_WIDTH - X_PADDING, 25.0);
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
    UIButton *searchButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [searchButton setTitle:@"Search tickets" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor systemGray2Color];
    searchButton.tintColor = [UIColor whiteColor];
    searchButton.frame = searchButtonFrame;
    searchButton.layer.cornerRadius = 5.0;
    [searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
}

// Search tickets
- (void)searchButtonDidTap:(UIButton *)sender {
    
    SearchResultViewController *searchResultViewController = [SearchResultViewController new];
    searchResultViewController.title = @"Found tickets";

    [self.navigationController pushViewController:searchResultViewController animated:YES];
}

-(void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc]initWithType:PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc]initWithType:PlaceTypeDestination];
    }
    
    placeViewController.delegate = self;
    [self.navigationController pushViewController:placeViewController animated:YES];
}

// MARK:- PlaceViewControllecDelegate

- (void)selectPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    
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
        _searchRequest.origin = iata;
        [_departureTextField setText:title];
    } else {
        _searchRequest.destionation = iata;
        [_destinationTextField setText:title];
    }
}

@end
