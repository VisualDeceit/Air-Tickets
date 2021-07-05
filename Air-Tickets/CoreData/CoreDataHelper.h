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

#define SORT_BY_PRICE @"sort.by.price"
#define SORT_BY_DATE @"sort.by.date"

typedef enum FavoriteSource {
    FavoriteSourceSearch,
    FavoriteSourcePriceMap,
} FavoriteSource;

typedef enum FavoriteSortType {
    FavoriteSortTypeDescPrice,
    FavoriteSortTypeAscPrice,
    FavoriteSortTypeDescDate,
    FavoriteSortTypeAscDate,
} FavoriteSortType;

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;
- (void)addToFavorite:(Ticket *)ticket from:(FavoriteSource)source;
- (void)removeFromFavorite:(Ticket *)ticket;
- (NSArray *)favorites:(FavoriteSource)source sort:(FavoriteSortType)sort;
- (BOOL)isFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
