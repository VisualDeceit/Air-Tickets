//
//  SearchResultViewController.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import <UIKit/UIKit.h>
#import "SearchTicketTableViewCell.h"
#import "PriceMapTicketTableViewCell.h"
#import "CoreDataHelper.h"

#define SearchTicketCellReuseIdentifier @"SearchCellIdentifier"
#define PriceMapCellReuseIdentifier @"PriceMapCellIdentifier"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initForFavoriteTickets;

@end

NS_ASSUME_NONNULL_END
