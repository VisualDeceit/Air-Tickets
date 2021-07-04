//
//  PlaceViewControllecDelegate.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 22.06.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PlaceType {
    PlaceTypeDeparture,
    PlaceTypeDestination
} PlaceType;

@protocol PlaceViewControllecDelegate <NSObject>

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType) dataType;

@end

NS_ASSUME_NONNULL_END
