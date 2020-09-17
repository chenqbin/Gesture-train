//
//  BDSAddTextContainerView.m
//  Aurum
//
//  Created by chenquanbin on 2019/12/6.
//

#import "BDSAddTextContainerView.h"

#define imageViewRadius 17.0

@interface BDSAddTextContainerView()

@property (nonatomic, strong) UIView *borderView;             //边框
@property (nonatomic, strong) UIImageView *closeImageView;    //左上的 X
@property (nonatomic, strong) UIImageView *resizeImageView;   //右下的缩放按钮
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation BDSAddTextContainerView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self buildView];
    }
    return self;
}

- (void)buildView {
    [self addSubview:self.borderView];
    [self addSubview:self.closeImageView];
    [self addSubview:self.resizeImageView];
    [self addSubview:self.textLabel];
    
    self.borderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.borderView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.borderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.borderView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.borderView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;

    self.closeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:-imageViewRadius].active = YES;
    [self.closeImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:-imageViewRadius].active = YES;
    [self.closeImageView.widthAnchor constraintEqualToConstant:imageViewRadius * 2].active = YES;
    [self.closeImageView.heightAnchor constraintEqualToConstant:imageViewRadius * 2].active = YES;

    self.resizeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resizeImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:imageViewRadius].active = YES;
    [self.resizeImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:imageViewRadius].active = YES;
    [self.resizeImageView.widthAnchor constraintEqualToConstant:imageViewRadius * 2].active = YES;
    [self.resizeImageView.heightAnchor constraintEqualToConstant:imageViewRadius * 2].active = YES;
    
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.textLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.textLabel.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    [self.textLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
}

#pragma mark - lazy load

- (UIView *)borderView{
    if(!_borderView){
        _borderView = [[UIView alloc]init];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _borderView.layer.borderWidth = 1.0;
        _borderView.layer.shadowOpacity = 0.3;
        _borderView.layer.shadowOffset = CGSizeMake(0, 1);
        _borderView.layer.shadowRadius = 2.0;
        _borderView.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return _borderView;
}

- (UIImageView *)closeImageView{
    if(!_closeImageView){
        UIImage *image = [UIImage imageNamed:@"labelCloseIcon"];
        _closeImageView = [[UIImageView alloc]initWithImage:image];
        _closeImageView.contentMode = UIViewContentModeCenter;
        _closeImageView.layer.shadowOpacity = 0.3;
        _closeImageView.layer.shadowOffset = CGSizeMake(0, 1);
        _closeImageView.layer.shadowRadius = 2.0;
        _closeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _closeImageView.userInteractionEnabled = YES;
    }
    return _closeImageView;
}

- (UIImageView *)resizeImageView{
    if(!_resizeImageView){
        UIImage *image = [UIImage imageNamed:@"labelResizeIcon"];
        _resizeImageView = [[UIImageView alloc]initWithImage:image];
        _resizeImageView.contentMode = UIViewContentModeCenter;
        _resizeImageView.layer.shadowOpacity = 0.3;
        _resizeImageView.layer.shadowOffset = CGSizeMake(0, 1);
        _resizeImageView.layer.shadowRadius = 2.0;
        _resizeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _resizeImageView.userInteractionEnabled = YES;
    }
    return _resizeImageView;
}

#pragma mark - override

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:30];
        _textLabel.textColor = [UIColor redColor];
        _textLabel.text = @"~^_^~";
    }
    return _textLabel;
}

@end
