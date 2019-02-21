//
//  ZDDInputView.m
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDInputView.h"

@interface ZDDInputView ()
/** 评论编辑框 */
@property (nonatomic, strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** placeHolder */
@property (nonatomic, strong) UILabel *placeHolder;
/** 最大高度 */
@property (nonatomic, assign) CGFloat  textInputMaxHeight;
/** lastH */
@property (nonatomic, assign) CGFloat lastH;

@end

@implementation ZDDInputView

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"text"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        
        [self addSubview:self.textView];
        [self addSubview:self.sendButton];
        [self addSubview:self.placeHolder];
        self.clipsToBounds = YES;
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.lastH = 40;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
        [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self.sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        [self textViewDidChange];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)setPlaceHolderString:(NSString *)placeHolderString {
    _placeHolderString = placeHolderString;
    self.placeHolder.text = placeHolderString;
    if (!self.textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
}

#pragma mark - Public 方法
- (void)sendSuccess {
    self.textView.text = nil;
    [self textViewDidChange];
}

#pragma mark - Action
- (void)sendBtnClick {
    if (self.sendBtnClickBlock) {
        self.sendBtnClickBlock();
    }
}

- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine
{
    _textViewMaxLine = textViewMaxLine;
    self.textInputMaxHeight = ceil(self.textView.font.lineHeight * (textViewMaxLine - 1) +
                                   self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange {
    
    if (!self.textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
    
    if (self.textView.text.length > 1000) {
        self.textView.text = [self.textView.text substringWithRange:NSMakeRange(0, 1000)];
    }
    
    NSInteger maxH = self.textInputMaxHeight;
    
    NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)].height);
    
    if (height > maxH) {
        height = maxH;
        self.textView.scrollEnabled = YES;   // 允许滚动
    } else {
        self.textView.scrollEnabled = NO;    // 不允许滚动
    }
    
    // 通知父控件改变约束
    if (_lastH != height) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + 11);
        }];
        
        [UIView animateWithDuration:0.20f animations:^{
            [self.superview layoutIfNeeded];//这里是关键
            //            if (self.editTalkViewHeightChangeBlock) {
            //                self.editTalkViewHeightChangeBlock();
            //            }
        } completion:^(BOOL finished) {
            //动画完成后的代码
        }];
        
        _lastH = height;
    }
}

-(void)setSendText:(NSString *)sendText {
    _sendText = sendText;
    [self.sendButton setTitle:sendText forState:UIControlStateNormal];
    
}

#pragma mark - 添加子控件的约束
- (void)makeSubViewsConstraints {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5.5);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-52);
        make.height.mas_equalTo(40);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textView.mas_bottom).offset(-5);
        make.right.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(31);
        make.width.mas_equalTo(42);
    }];
    
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.textView);
        make.left.mas_equalTo(self.textView).offset(12);
        make.right.mas_equalTo(self.textView);
    }];
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [UIColor blackColor];        _textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
        _textView.scrollEnabled = YES;
        _textView.layer.cornerRadius = 20;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [color(137, 137, 137, 0.5) CGColor];
        _textView.layer.borderWidth = 0.5;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _sendButton;
}

- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc] init];
        _placeHolder.font = [UIFont systemFontOfSize:16];
        _placeHolder.textColor = color(237, 237, 237, 1);
        _placeHolder.text = @"写评论";
    }
    return _placeHolder;
}

@end
