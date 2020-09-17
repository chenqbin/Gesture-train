//
//  BDSAddTextView.m
//  AFgzipRequestSerializer
//
//  Created by chenquanbin on 2019/10/22.
//

#import "BDSAddTextView.h"
#import "BDSAddTextContainerView.h"

@interface BDSAddTextView()

@property (nonatomic, strong) BDSAddTextContainerView *textContainer;

@end

@implementation BDSAddTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __buildView];
    }
    return self;
}

- (void)__buildView {
    [self addSubview:self.textContainer];
    self.textContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textContainer.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.textContainer.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
}

#pragma mark - lazy load

- (BDSAddTextContainerView *)textContainer{
    if(!_textContainer){
        _textContainer = [[BDSAddTextContainerView alloc]init];
    }
    return _textContainer;
}

#pragma mark - Gesture


@end
