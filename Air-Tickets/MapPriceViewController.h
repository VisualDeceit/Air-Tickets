//
//  MapPriceViewController.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 29.06.2021.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"
#import "APIManager.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapPriceViewController : UIViewController

- (instancetype)initWithLocation:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
