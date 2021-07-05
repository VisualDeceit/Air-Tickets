//
//  PriceMapTicketTableViewCell.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

NS_ASSUME_NONNULL_BEGIN

@interface PriceMapTicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
