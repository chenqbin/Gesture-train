//
//  BDSAddTextView.m
//  AFgzipRequestSerializer
//
//  Created by chenquanbin on 2019/10/22.
//

#import "BDSAddTextView.h"
#import <BDSImageEditorModule/BDSAddTextContainerView.h>

@interface BDSAddTextView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray<BDSAddTextContainerView *> *containerViews;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;
@property (nonatomic, assign) CGAffineTransform originTranslate; //移动时初始位移
@property (nonatomic, assign) CGPoint originCenter; //移动时中心点初始位置
@property (nonatomic, assign) CGPoint preLocation; //单指旋转时，缩放按钮上一次的位置

@end

@implementation BDSAddTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.function = BDSFunctionTypeText;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureDidInvoke:)];
        [self addGestureRecognizer:tapGesture];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(labelPinchGestureDidInvoke:)];
        self.pinchGesture.delegate = self;
        self.pinchGesture.enabled = NO;
        [self addGestureRecognizer:self.pinchGesture];
        
        self.rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(labelRotationGestureDidInvoke:)];
        self.rotationGesture.delegate = self;
        self.rotationGesture.enabled = NO;
        [self addGestureRecognizer:self.rotationGesture];
    }
    return self;
}


- (CGPoint)scrollViewCenter{
    BDSZoomScrollView *zoomView = self.zoomView;
    if(zoomView){
        return [zoomView.zoomView convertPoint:CGPointMake(CGRectGetMidX(zoomView.zoomView.bounds), CGRectGetMidY(zoomView.zoomView.bounds)) toView:self];
    }
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (BDSAddTextContainerView *)highlightedLabel{
    for(BDSAddTextContainerView *containerView in self.containerViews){
        if(containerView.highlighted){
            return containerView;
        }
    }
    return nil;
}

- (void)unhighlightAllLabels{
    for(BDSAddTextContainerView *containerView in self.containerViews){
        containerView.highlighted = NO;
    }
    self.pinchGesture.enabled = NO;
    self.rotationGesture.enabled = NO;
}

- (void)highlight:(BDSAddTextContainerView *)highLightLabel {
    for(BDSAddTextContainerView *containerView in self.containerViews){
        if(containerView == highLightLabel){
            containerView.highlighted = YES;
            self.pinchGesture.enabled = YES;
            self.rotationGesture.enabled = YES;
        } else{
            containerView.highlighted = NO;
        }
    }
}

- (void)addContainerViewWithLabel:(UIView<BDSAddTextLabelProtocol> *)label{
    if(!label){
        return;
    }
    BDSAddTextContainerView *containerView = [[BDSAddTextContainerView alloc]initWithLabel:label];
    containerView.center = self.scrollViewCenter;
    [self addContainerView:containerView];
}

- (void)addContainerView:(BDSAddTextContainerView *)containerView{
    if(!containerView){
        return;
    }
    
    if(self.imageUndoManager){
        [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
            [target removeLabel:containerView];
        }];
        if (self.undoStackChangeBlock) {
            self.undoStackChangeBlock();
        }
    }
    [containerView.tapGesture addTarget:self action:@selector(labelTapGestureDidInvoke:)];
    [containerView.panGesture addTarget:self action:@selector(labelPanGestureDidInvoke:)];
    [containerView.closeTapGesture addTarget:self action:@selector(labelCloseGestureDidInvoke:)];
    [containerView.resizePanGesture addTarget:self action:@selector(labelResizeGestureDidInvoke:)];
    
    NSMutableArray *tempArray = [self.containerViews mutableCopy];
    [tempArray addObject:containerView];
    self.containerViews = [tempArray copy];
    [self addSubview:containerView];
    [self highlight:containerView];
    
    CGAffineTransform originTransform = containerView.transform;
    containerView.transform = CGAffineTransformIdentity;
    containerView.center = self.scrollViewCenter;
    [containerView layoutIfNeeded];
    containerView.transform = originTransform;
}

- (void)removeLabel:(BDSAddTextContainerView *)containerView{
    if(!containerView){
        return;
    }
    
    if(self.imageUndoManager){
        [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
            [target addContainerView:containerView];
        }];
        if (self.undoStackChangeBlock) {
            self.undoStackChangeBlock();
        }
    }
    NSMutableArray *tempArray = [self.containerViews mutableCopy];
    for(BDSAddTextContainerView *tempLabel in tempArray){
        if(tempLabel == containerView){
            [tempArray removeObject:tempLabel];
            [tempLabel removeFromSuperview];
            self.containerViews = [tempArray copy];
            break;
        }
    }
    
    if(self.highlightedLabel){
        self.pinchGesture.enabled = YES;
        self.rotationGesture.enabled = YES;
    } else{
        self.pinchGesture.enabled = NO;
        self.rotationGesture.enabled = NO;
    }
}

- (void)updateContainerView:(BDSAddTextContainerView *)containerView withLabel:(UIView<BDSAddTextLabelProtocol> *)newLabel{
    if(self.imageUndoManager){
        UIView<BDSAddTextLabelProtocol> *oldLabel = containerView.label;
        [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
            [target updateContainerView:containerView withLabel:oldLabel];
        }];
        if (self.undoStackChangeBlock) {
            self.undoStackChangeBlock();
        }
    }
    CGAffineTransform originTransform = containerView.transform;
    containerView.transform = CGAffineTransformIdentity;
    containerView.label = newLabel;
    [containerView layoutIfNeeded];
    containerView.transform = originTransform;
}

- (CGFloat)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2{
    CGFloat deltaX = point1.x - point2.x;
    CGFloat deltaY = point1.y - point2.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}

- (CGFloat)angelBetweenVec1:(CGVector)vec1 andVec2:(CGVector)vec2{
    return atan2(vec2.dy, vec2.dx) - atan2(vec1.dy, vec1.dx);
}

#pragma mark - lazy load

- (NSArray<BDSAddTextContainerView *> *)containerViews{
    if(!_containerViews){
        _containerViews = [NSArray array];
    }
    return _containerViews;
}

#pragma mark - override

- (void)becomeDeactive{
    [super becomeDeactive];
    [self unhighlightAllLabels];
}

- (BOOL)clearSubview{
    if(!self.subviews.count && !self.containerViews.count){
        return NO;
    }
    
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
    self.containerViews = [NSArray array];
    return YES;
}

- (BOOL)hasOperated{
    return self.hasOperatedBeforeCrop || self.containerViews.count;
}

#pragma mark - Gesture

- (void)tapGestureDidInvoke:(UITapGestureRecognizer *)tapGesture{
    if(self.highlightedLabel){
        [self unhighlightAllLabels];
    } else{
        self.didTapBlankBlock? self.didTapBlankBlock() : nil;
    }
}

- (void)labelTapGestureDidInvoke:(UITapGestureRecognizer *)tapGesture{
    if(![tapGesture.view isKindOfClass:[BDSAddTextContainerView class]]){
        return;
    }
    BDSAddTextContainerView *containerView = (BDSAddTextContainerView *)tapGesture.view;
    if(containerView.highlighted){
        [self.delegate respondsToSelector:@selector(updateContainerViewWithLabel:withCompletion:)] ?
        [self.delegate updateContainerViewWithLabel:containerView.label withCompletion:^(UIView<BDSAddTextLabelProtocol> *newLabel) {
            if(!newLabel){
                [self removeLabel:containerView];
            } else{
                [self updateContainerView:containerView withLabel:newLabel];
            }
        }] : nil;
    } else {
        [self highlight:containerView];
    }
}

- (void)labelPanGestureDidInvoke:(UIPanGestureRecognizer *)panGesture{
    if(![panGesture.view isKindOfClass:[BDSAddTextContainerView class]]){
        return;
    }
    BDSAddTextContainerView *containerView = (BDSAddTextContainerView *)panGesture.view;
    [self highlight:containerView];
    
    switch (panGesture.state){
        case UIGestureRecognizerStateBegan:{
            self.didBeginOperateBlock ? self.didBeginOperateBlock() : nil;
            if(self.imageUndoManager){
                CGAffineTransform originZoom = containerView.zoomTransform;
                CGAffineTransform originRotation = containerView.rotationTransform;
                CGAffineTransform originTranslate = containerView.translateTransform;
                self.originTranslate = containerView.translateTransform;
                self.originCenter = CGPointApplyAffineTransform(containerView.center, containerView.translateTransform);
                [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
                    containerView.zoomTransform = originZoom;
                    containerView.rotationTransform = originRotation;
                    containerView.translateTransform = originTranslate;
                    [containerView setTransformForZoom:originZoom rotation:originRotation translate:originTranslate];
                }];
                if (self.undoStackChangeBlock) {
                    self.undoStackChangeBlock();
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint vector = [panGesture translationInView:self];
            CGFloat newCenterX = MIN(self.originCenter.x + vector.x, CGRectGetMaxX(self.bounds));
            newCenterX = MAX(newCenterX, CGRectGetMinX(self.bounds));
            CGFloat newCenterY = MIN(self.originCenter.y + vector.y, CGRectGetMaxY(self.bounds));
            newCenterY = MAX(newCenterY, CGRectGetMinY(self.bounds));
            containerView.translateTransform = CGAffineTransformTranslate(self.originTranslate, newCenterX - self.originCenter.x, newCenterY - self.originCenter.y);
            [containerView setTransformForZoom:containerView.zoomTransform rotation:containerView.rotationTransform translate:containerView.translateTransform];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
            self.didFinishOperateBlock ? self.didFinishOperateBlock() : nil;
            break;
        }
        default:
            break;
    }
}

- (void)labelCloseGestureDidInvoke:(UITapGestureRecognizer *)tapGesture{
    if(![tapGesture.view.superview isKindOfClass:[BDSAddTextContainerView class]]){
        return;
    }
    BDSAddTextContainerView *containerView = (BDSAddTextContainerView *)tapGesture.view.superview;
    [self removeLabel:containerView];
}

- (void)labelResizeGestureDidInvoke:(UIPanGestureRecognizer *)panGesture{
    if(![panGesture.view.superview isKindOfClass:[BDSAddTextContainerView class]]){
        return;
    }
    BDSAddTextContainerView *containerView = (BDSAddTextContainerView *)panGesture.view.superview;
    [self highlight:containerView];

    switch (panGesture.state){
        case UIGestureRecognizerStateBegan:{
            self.didBeginOperateBlock ? self.didBeginOperateBlock() : nil;
            if(self.imageUndoManager){
                CGAffineTransform originZoom = containerView.zoomTransform;
                CGAffineTransform originRotation = containerView.rotationTransform;
                CGAffineTransform originTranslate = containerView.translateTransform;
                self.preLocation = [panGesture locationInView:containerView.superview];
                [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
                    containerView.zoomTransform = originZoom;
                    containerView.rotationTransform = originRotation;
                    containerView.translateTransform = originTranslate;
                    [containerView setTransformForZoom:originZoom rotation:originRotation translate:originTranslate];
                }];
                if (self.undoStackChangeBlock) {
                    self.undoStackChangeBlock();
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint location = [panGesture locationInView:containerView.superview];
            CGRect originFrame = containerView.frame;
            CGFloat originDistance = [self distanceBetweenPoint1:CGPointMake(CGRectGetMaxX(containerView.bounds), CGRectGetMaxY(containerView.bounds)) andPoint2:CGPointMake(CGRectGetMidX(containerView.bounds), CGRectGetMidY(containerView.bounds))];
            CGFloat currentDistance = [self distanceBetweenPoint1:location andPoint2:CGPointMake(CGRectGetMidX(originFrame), CGRectGetMidY(originFrame))];
            CGFloat scaleRatio = currentDistance / originDistance;
            scaleRatio = MIN(84 / 30.0, scaleRatio);
            scaleRatio = MAX(14 / 30.0, scaleRatio);
            containerView.zoomTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
            
            CGVector vec1 = CGVectorMake(self.preLocation.x - CGRectGetMidX(originFrame), self.preLocation.y - CGRectGetMidY(originFrame));
            CGVector vec2 = CGVectorMake(location.x - CGRectGetMidX(originFrame), location.y - CGRectGetMidY(originFrame));
            CGFloat radians = [self angelBetweenVec1:vec1 andVec2: vec2];
            containerView.rotationTransform = CGAffineTransformRotate(containerView.rotationTransform, radians);
            [containerView setTransformForZoom:containerView.zoomTransform rotation:containerView.rotationTransform translate:containerView.translateTransform];
            self.preLocation = location;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
            self.didFinishOperateBlock ? self.didFinishOperateBlock() : nil;
            break;
        }
        default:
            break;
    }
}

- (void)labelPinchGestureDidInvoke:(UIPinchGestureRecognizer *)pinchGesture{
    BDSAddTextContainerView *containerView = self.highlightedLabel;
    if(![pinchGesture.view isKindOfClass:[BDSAddTextView class]] || !containerView){
        return;
    }
    
    switch (pinchGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.didBeginOperateBlock ? self.didBeginOperateBlock() : nil;
            if(self.imageUndoManager){
                CGSize originSize = containerView.bounds.size;
                CGSize currentSize = CGSizeApplyAffineTransform(originSize, containerView.zoomTransform);
                CGFloat currentScale = currentSize.height / originSize.height;
                pinchGesture.scale = currentScale * pinchGesture.scale;
                CGAffineTransform originZoom = containerView.zoomTransform;
                CGAffineTransform originRotation = containerView.rotationTransform;
                CGAffineTransform originTranslate = containerView.translateTransform;
                [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
                    containerView.zoomTransform = originZoom;
                    containerView.rotationTransform = originRotation;
                    containerView.translateTransform = originTranslate;
                    [containerView setTransformForZoom:originZoom rotation:originRotation translate:originTranslate];
                }];
                if (self.undoStackChangeBlock) {
                    self.undoStackChangeBlock();
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            containerView.transform = CGAffineTransformIdentity;
            CGFloat scaleRatio = pinchGesture.scale;
            scaleRatio = MIN(84 / 30.0, scaleRatio);
            scaleRatio = MAX(14 / 30.0, scaleRatio);
            containerView.zoomTransform = CGAffineTransformScale(containerView.transform, scaleRatio, scaleRatio);
            [containerView setTransformForZoom:containerView.zoomTransform rotation:containerView.rotationTransform translate:containerView.translateTransform];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
            self.didFinishOperateBlock ? self.didFinishOperateBlock() : nil;
            break;
        }
        default:
            break;
    }
}

- (void)labelRotationGestureDidInvoke:(UIRotationGestureRecognizer *)rotationGesture{
    BDSAddTextContainerView *label = self.highlightedLabel;
    if(![rotationGesture.view isKindOfClass:[BDSAddTextView class]] || !label){
        return;
    }
    
    switch (rotationGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.didBeginOperateBlock ? self.didBeginOperateBlock() : nil;
            if(self.imageUndoManager){
                CGAffineTransform originZoom = label.zoomTransform;
                CGAffineTransform originRotation = label.rotationTransform;
                CGAffineTransform originTranslate = label.translateTransform;
                [self.imageUndoManager registerUndoWithTarget:self handler:^(id  _Nonnull target) {
                    label.zoomTransform = originZoom;
                    label.rotationTransform = originRotation;
                    label.translateTransform = originTranslate;
                    [label setTransformForZoom:originZoom rotation:originRotation translate:originTranslate];
                }];
                if (self.undoStackChangeBlock) {
                    self.undoStackChangeBlock();
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            label.rotationTransform = CGAffineTransformRotate(label.rotationTransform, rotationGesture.rotation);
            [label setTransformForZoom:label.zoomTransform rotation:label.rotationTransform translate:label.translateTransform];
            rotationGesture.rotation = 0;
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:{
            self.didFinishOperateBlock ? self.didFinishOperateBlock() : nil;
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(!([gestureRecognizer.view isKindOfClass:[BDSAddTextView class]] && [otherGestureRecognizer.view isKindOfClass:[BDSAddTextView class]])){
        return NO;
    }
    if (([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]
         || [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) &&
        ([otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]
         || [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])) {
            return YES;
    }
    
    return NO;
}

@end
