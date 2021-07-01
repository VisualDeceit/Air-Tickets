//
//  LocationService.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 29.06.2021.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

NS_ASSUME_NONNULL_BEGIN

@interface LocationService : NSObject <CLLocationManagerDelegate>

@end

NS_ASSUME_NONNULL_END
