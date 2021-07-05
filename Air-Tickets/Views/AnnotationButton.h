//
//  AnnotationButton.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <UIKit/UIKit.h>
#import "PriceMapAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnotationButton : UIButton

@property (nonatomic, weak) PriceMapAnnotation *annotation;

@end

NS_ASSUME_NONNULL_END
