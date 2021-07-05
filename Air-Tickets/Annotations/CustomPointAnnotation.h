//
//  CustomPointAnnotation.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <MapKit/MapKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
