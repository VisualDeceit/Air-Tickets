//
//  CoreDataHelper.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 04.07.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteTicketMO+CoreDataClass.h"
#import "FavoriteTicketMO+CoreDataProperties.h"
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (BOOL)isFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
