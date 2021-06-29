//
//  SearchResultViewController.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 18.06.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTickets:(NSArray *)tickets;

@end

NS_ASSUME_NONNULL_END
