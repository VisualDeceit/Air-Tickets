//
//  SearchTicketTableViewCell.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 24.06.2021.
//

#import "SearchTicketTableViewCell.h"
#import "APIManager.h"

@interface SearchTicketTableViewCell()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *favoriteSign;

@end

@implementation SearchTicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
        _placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
        [self.contentView addSubview:_dateLabel];
        
        _favoriteSign = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"star.fill"]];
        _favoriteSign.contentMode = UIViewContentModeScaleAspectFit;
        _favoriteSign.tintColor = [UIColor labelColor];
        [self.contentView addSubview:_favoriteSign];  
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
    _favoriteSign.frame = CGRectMake(self.contentView.frame.size.width - 28, self.contentView.frame.size.height - 28, 20, 20);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    
    if (_showFavoriteSign) {
        [_favoriteSign setHidden:NO];
    } else {
        [_favoriteSign setHidden:YES];
    }
    
    NSURL *urlLogo = AirlineLogo(ticket.airline);
    
    NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession] downloadTaskWithURL:urlLogo completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage  *downloadedImage = [UIImage imageWithData:
            [NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_airlineLogoView.image = downloadedImage;
        });
    }];
    [downloadLogoTask resume];
}

- (void)setFavoriteTicket:(FavoriteTicketMO *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    
    [_favoriteSign setHidden:YES];
    
    NSURL *urlLogo = AirlineLogo(favoriteTicket.airline);
    
    NSURLSessionDownloadTask *downloadLogoTask = [[NSURLSession sharedSession] downloadTaskWithURL:urlLogo completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage  *downloadedImage = [UIImage imageWithData:
            [NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_airlineLogoView.image = downloadedImage;
        });
    }];
    [downloadLogoTask resume];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _priceLabel.text = @"";
    _placesLabel.text = @"";
    _dateLabel.text = @"";
    _airlineLogoView.image = nil;
}
@end
