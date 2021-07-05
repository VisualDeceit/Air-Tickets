//
//  CustomPointAnnotation.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <MapKit/MapKit.h>
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MKFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) MapPrice *price;

@end

NS_ASSUME_NONNULL_END
