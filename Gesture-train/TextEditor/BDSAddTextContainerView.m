//
//  BDSAddTextContainerView.m
//  Aurum
//
//  Created by chenquanbin on 2019/12/6.
//

#import "BDSAddTextContainerView.h"
#import <BDSImageEditorModule/BDSAddTextViewProtocol.h>

#define imageViewRadius 17.0

@interface BDSAddTextContainerView()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIImageView *resizeImageView;

@property (nonatomic, strong) NSLayoutConstraint *labelCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelCenterYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;

@end

@implementation BDSAddTextContainerView

- (instancetype)initWithLabel:(UIView<BDSAddTextLabelProtocol> *)label{
    self = [super init];
    if (self) {
        self.zoomTransform = CGAffineTransformIdentity;
        self.rotationTransform = CGAffineTransformIdentity;
        self.translateTransform = CGAffineTransformIdentity;
        self.label = label;
        [self buildView];
        self.tapGesture = [[UITapGestureRecognizer alloc]init];
        [self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc]init];
        [self addGestureRecognizer:self.panGesture];
        self.closeTapGesture = [[UITapGestureRecognizer alloc]init];
        [self.closeImageView addGestureRecognizer:self.closeTapGesture];
        self.resizePanGesture = [[UIPanGestureRecognizer alloc]init];
        [self.resizeImageView addGestureRecognizer:self.resizePanGesture];
        
        [self.tapGesture requireGestureRecognizerToFail:self.closeTapGesture];
        [self.tapGesture requireGestureRecognizerToFail:self.resizePanGesture];
        [self.panGesture requireGestureRecognizerToFail:self.closeTapGesture];
        [self.panGesture requireGestureRecognizerToFail:self.resizePanGesture];
    }
    return self;
}

- (void)buildView{
    [self addSubview:self.borderView];
    [self addSubview:self.closeImageView];
    [self addSubview:self.resizeImageView];

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
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BDSImageEditorModule" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        _closeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelCloseIcon" inBundle:bundle compatibleWithTraitCollection:nil]];
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
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"BDSImageEditorModule" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        _resizeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"labelResizeIcon" inBundle:bundle compatibleWithTraitCollection:nil]];
        _resizeImageView.contentMode = UIViewContentModeCenter;
        _resizeImageView.layer.shadowOpacity = 0.3;
        _resizeImageView.layer.shadowOffset = CGSizeMake(0, 1);
        _resizeImageView.layer.shadowRadius = 2.0;
        _resizeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _resizeImageView.userInteractionEnabled = YES;
    }
    return _resizeImageView;
}

- (void)updateLabelConstraint{
    self.labelCenterXConstraint.active = NO;
    self.labelCenterXConstraint = [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    self.labelCenterXConstraint.active = YES;
    
    self.labelCenterYConstraint.active = NO;
    self.labelCenterYConstraint = [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    self.labelCenterYConstraint.active = YES;
    
    self.labelWidthConstraint.active = NO;
    self.labelWidthConstraint = [self.label.widthAnchor constraintEqualToConstant:[self.label originViewSize].width];
    self.labelWidthConstraint.active = YES;

    self.labelHeightConstraint.active = NO;
    self.labelHeightConstraint = [self.label.heightAnchor constraintEqualToConstant:[self.label originViewSize].height];
    self.labelHeightConstraint.active = YES;
}

#pragma mark - override

- (void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    self.closeImageView.hidden = !highlighted;
    self.resizeImageView.hidden = !highlighted;
    self.borderView.hidden = !highlighted;
}

- (void)setLabel:(UIView<BDSAddTextLabelProtocol> *)label{
    if(_label != label){
        [_label removeFromSuperview];
        _label = label;
        _label.userInteractionEnabled = NO;
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:_label atIndex:0];
    }
    [self updateLabelConstraint];
    self.bounds = CGRectMake(0, 0, [_label originViewSize].width, [_label originViewSize].height);
}

- (void)setTransformForZoom:(CGAffineTransform)zoomTransform rotation:(CGAffineTransform)rotationTransform translate:(CGAffineTransform)translateTransform{
    [super setTransform:zoomTransform];
    [super setTransform:CGAffineTransformConcat(self.transform, rotationTransform)];
    [super setTransform:CGAffineTransformConcat(self.transform, translateTransform)];
    
    CGAffineTransform reverseZoom = CGAffineTransformInvert(zoomTransform);
    [self.closeImageView setTransform:reverseZoom];
    [self.resizeImageView setTransform:reverseZoom];
    
    CGSize newSize = CGSizeApplyAffineTransform(self.bounds.size, zoomTransform);
    CGFloat ratio = newSize.height / self.bounds.size.height;
    self.borderView.layer.borderWidth = 1 / ratio;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint convertPoint = [self convertPoint:point toView:self.closeImageView];
    if([self.closeImageView pointInside:convertPoint withEvent:event]){
        return YES;
    }
    
    convertPoint = [self convertPoint:point toView:self.resizeImageView];
    if([self.resizeImageView pointInside:convertPoint withEvent:event]){
        return YES;
    }
    
    return [super pointInside:point withEvent:event];
}

@end
