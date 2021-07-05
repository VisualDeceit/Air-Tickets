//
//  PriceMapAnnotation.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <MapKit/MapKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface PriceMapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    Ticket *ticket;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
