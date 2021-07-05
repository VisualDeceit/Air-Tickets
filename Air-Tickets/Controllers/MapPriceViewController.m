//
//  MapPriceViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 29.06.2021.
//

#import "MapPriceViewController.h"

@interface MapPriceViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;
@property (nonatomic, strong) LocationService *locationService;

@end

@implementation MapPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    [self configureMap];
}

- (void)configureUI {
    self.title = @"Price map";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureMap {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _locationService = [[LocationService alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        
        AnnotationButton *addToFavoritesButton = [AnnotationButton systemButtonWithImage:[UIImage systemImageNamed:@"star"] target:self action:@selector(addToFavoritesButtonDidTap:)];
        addToFavoritesButton.tintColor = [UIColor labelColor];
        annotationView.rightCalloutAccessoryView = addToFavoritesButton;
        addToFavoritesButton.annotation = (CustomPointAnnotation *)annotation;
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            
            Ticket *ticket = [[Ticket alloc] initWithPrice:price];
            annotation.ticket = ticket;
            
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (void)addToFavoritesButtonDidTap:(AnnotationButton *)button {
    NSLog(@"%@", [button.annotation.ticket description]);
    [[CoreDataHelper sharedInstance] addToFavorite:button.annotation.ticket from:FavoriteSourcePriceMap];
}

@end
