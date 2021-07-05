//
//  Ticket.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import "Ticket.h"

@implementation Ticket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _airline = [dictionary valueForKey:@"airline"];
        _expires = dateFromString([dictionary valueForKey:@"expires_at"]);
        _departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        _flightNumber = [dictionary valueForKey:@"flight_number"];
        _price = [dictionary valueForKey:@"price"];
        _returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
    }
    return self;
}

- (instancetype)initWithPrice:(MapPrice *)price {
    self = [super init];
    if (self) {
        _price = @(price.value);
        _airline = @"none";
        _departure = price.departure;
        _expires = [NSDate now];
        _flightNumber = @0;
        _returnDate = price.returnDate;
        _from = price.origin.code;
        _to = price.destination.code;
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd'T'HH:mm:ssZ"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Moscow"]];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

@end
