//
//  MapPriceViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 29.06.2021.
//

#import "MapPriceViewController.h"

@interface MapPriceViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapPriceViewController

- (instancetype)initWithLocation:(CLLocation *)location {
    self = [super init];
    if (self) {
        _currentLocation = location;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    [self configureMap];
}

- (void)configureUI {
    self.title = @"Price map";
}

- (void)configureMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    if (_currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:_currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
        });
    }
}

@end
