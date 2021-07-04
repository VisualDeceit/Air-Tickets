//
//  TicketTableViewCell.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "CoreDataHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;
@property (nonatomic, strong) FavoriteTicketMO *favoriteTicket;
@property (nonatomic) BOOL showFavoriteSign;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
