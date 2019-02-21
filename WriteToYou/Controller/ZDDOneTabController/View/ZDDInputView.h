//
//  ZDDInputView.h
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sendClickBlock)(void);

@interface ZDDInputView : UIView

/** 发送按钮点击的block */
@property (nonatomic, strong) sendClickBlock sendBtnClickBlock;
/** 评论编辑框 */
@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, strong) NSString *placeHolderString;
/** 右边按钮名字 */
@property (nonatomic, strong) NSString *sendText;
/** 允许输入的最大行数 */
@property (nonatomic, assign) NSInteger  textViewMaxLine;
/**
 消息发送成功后, 外界要调此方法还原textView的高度
 */
- (void)sendSuccess;
@end

NS_ASSUME_NONNULL_END
