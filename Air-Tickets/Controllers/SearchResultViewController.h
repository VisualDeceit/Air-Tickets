//
//  SearchResultViewController.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import <UIKit/UIKit.h>
#import "SearchTicketTableViewCell.h"
#import "CoreDataHelper.h"
#import "NotificationCenter.h"

#define SearchTicketCellReuseIdentifier @"SearchCellIdentifier"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initForFavoriteTickets;

@end

NS_ASSUME_NONNULL_END
