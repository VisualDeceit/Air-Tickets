//
//  WalkthroughViewController.m
//  Air-Tickets
//
//  Created by Alexander Fomin on 13.07.2021.
//

#import "WalkthroughViewController.h"

@interface WalkthroughViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation WalkthroughViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 125.0, [UIScreen mainScreen].bounds.size.height/2 - 200.0, 250.0, 300.0)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.layer.cornerRadius = 8.0;
        _imageView.clipsToBounds = YES;
        [self.view addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMinY(_imageView.frame) - 61.0, 200.0, 21.0)];
        _titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightHeavy];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMaxY(_imageView.frame) + 20.0, 200.0, 21.0)];
        _contentLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_contentLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    float height = heightForText(title, _titleLabel.font, 200.0);
    _titleLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMinY(_imageView.frame) - 40.0 - height, 200.0, height);
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    _contentLabel.text = contentText;
    float height = heightForText(contentText, _contentLabel.font, 200.0);
    _contentLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100.0, CGRectGetMaxY(_imageView.frame) + 20.0, 200.0, height);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

float heightForText(NSString *text, UIFont *font, float width) {
    if (text && [text isKindOfClass:[NSString class]]) {
        CGSize size = CGSizeMake(width, FLT_MAX);
        CGRect needLabel = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return ceilf(needLabel.size.height);
    }
    return 0.0;
}


@end
