//
//  AnnotationButton.h
//  Air-Tickets
//
//  Created by Alexander Fomin on 05.07.2021.
//

#import <UIKit/UIKit.h>
#import "CustomPointAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnotationButton : UIButton

@property (nonatomic, weak) CustomPointAnnotation *annotation;

@end

NS_ASSUME_NONNULL_END
