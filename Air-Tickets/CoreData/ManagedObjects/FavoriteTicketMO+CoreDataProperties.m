//
//  FavoriteTicketMO+CoreDataProperties.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 04.07.2021.
//
//

#import "FavoriteTicketMO+CoreDataProperties.h"

@implementation FavoriteTicketMO (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicketMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic flightNumber;
@dynamic price;
@dynamic to;
@dynamic from;
@dynamic departure;
@dynamic airline;
@dynamic returnDate;
@dynamic expires;
@dynamic created;

@end
