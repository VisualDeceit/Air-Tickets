//
//  Ticket.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import <Foundation/Foundation.h>
#import "MapPrice.h"

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithPrice:(MapPrice *)price;

@end

NS_ASSUME_NONNULL_END
