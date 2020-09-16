//
//  BDSAddTextContainerView.h
//  Aurum
//
//  Created by chenquanbin on 2019/12/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDSAddTextLabelProtocol;

@interface BDSAddTextContainerView : UIView

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *closeTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *resizePanGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGAffineTransform zoomTransform;
@property (nonatomic, assign) CGAffineTransform rotationTransform;
@property (nonatomic, assign) CGAffineTransform translateTransform;
@property (nonatomic, strong) UIView<BDSAddTextLabelProtocol> *label;

- (instancetype)initWithLabel:(UIView<BDSAddTextLabelProtocol> *)label;
- (void)setTransformForZoom:(CGAffineTransform)zoomTransform rotation:(CGAffineTransform)rotationTransform translate:(CGAffineTransform)translateTransform;

@end

NS_ASSUME_NONNULL_END
