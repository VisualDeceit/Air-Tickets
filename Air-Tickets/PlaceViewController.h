//
//  PlaceViewController.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 22.06.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PlaceViewControllecDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak, nullable) id<PlaceViewControllecDelegate> delegate;

@property (nonatomic,copy) void (^onSelectPlace)(id place, PlaceType placeType, DataSourceType dataType);

- (instancetype)initWithType: (PlaceType)type;

@end

NS_ASSUME_NONNULL_END
