//
//  BDSAddTextView.h
//  AFgzipRequestSerializer
//
//  Created by chenquanbin on 2019/10/22.
//

#import "BDSImageEditBaseView.h"
#import <BDSImageEditorModule/BDSAddTextViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class BDSAddTextContainerView;

@protocol BDSAddTextViewDelegate <NSObject>

- (void)updateContainerViewWithLabel:(UIView<BDSAddTextLabelProtocol> *)oldLabel withCompletion:(editTextFinishBlock)completion;

@end

@interface BDSAddTextView : BDSImageEditBaseView

@property (nonatomic, weak) id<BDSAddTextViewDelegate>delegate;

- (void)addContainerViewWithLabel:(UIView<BDSAddTextLabelProtocol> *)label;
- (BDSAddTextContainerView *)highlightedLabel;

- (void)unhighlightAllLabels;

@end

NS_ASSUME_NONNULL_END
