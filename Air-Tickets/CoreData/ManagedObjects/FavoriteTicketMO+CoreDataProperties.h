//
//  FavoriteTicketMO+CoreDataProperties.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 04.07.2021.
//
//

#import "FavoriteTicketMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicketMO (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicketMO *> *)fetchRequest;

@property (nonatomic) int16_t flightNumber;
@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
