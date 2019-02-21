//
//  ZDDThreeLineCommentView.m
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLineCommentView.h"
#import "ZDDInputView.h"
#import "ZDDThreeLineCommentCellNode.h"

#define topInsert 200
#define commentViewHeight SCREENHEIGHT - topInsert

@interface ZDDThreeLineCommentView () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) UIButton *masking;
@property (nonatomic, strong) UIView *bgWhiteView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) ZDDInputView *inputView;
@property (nonatomic, assign) BOOL isForgiveFirstResponse;
@property (nonatomic, strong) ZDDThreeLineModel *model;
@end

@implementation ZDDThreeLineCommentView

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self addNotiObser];
        [self setupUI];
        self.titleLb.text = @"共 1999条评论";
    }
    return self;
}

- (void)addNotiObser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupUI {
    
    [self addSubview:self.masking];
    [self.masking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:self.bgWhiteView];
    self.bgWhiteView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, commentViewHeight);
    
    [self.bgWhiteView addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.bgWhiteView addSubview:self.tableNode.view];
    [self.tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-51);
    }];
    
    [self.bgWhiteView addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(51);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputView resignFirstResponder];
}

#pragma mark - 发送评论
- (void)sendComment {
    
    self.inputView.textView.text = @"";
    [self.inputView resignFirstResponder];
    
    
}


#pragma mark 显示评论
-(void)showWithModel:(ZDDThreeLineModel *)model
{
    self.model = model;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.masking.alpha = 0.5;
        self.bgWhiteView.y = topInsert;
    }];
    [self addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(10, 10) view:self.bgWhiteView];
}
/** 隐藏 */
-(void)dismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        self.masking.alpha = 0.0f;
        self.bgWhiteView.y = SCREENHEIGHT;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - noti Action
- (void)kbWillShow:(NSNotification *)noti {
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.获取键盘的高度
    CGRect kbFrame =  [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    
    // 2.更改约束
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kbHeight);
        make.height.mas_equalTo(self.inputView.frame.size.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
    self.isForgiveFirstResponse =  NO;
    
}

- (void)kbWillHide:(NSNotification *)noti {
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (self.isForgiveFirstResponse) {
        return;
    }
    self.isForgiveFirstResponse =  YES;
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.inputView.height);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
    [self.inputView.textView resignFirstResponder];
}

#pragma mark - tableNodeDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode * {
        ZDDThreeLineCommentCellNode *cell = [[ZDDThreeLineCommentCellNode alloc] init];
        return cell;
    };
    
}


-(ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableNode.backgroundColor = [UIColor whiteColor];
        _tableNode.view.estimatedRowHeight = 0;
        _tableNode.leadingScreensForBatching = 1.0;
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableNode;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:13];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor blackColor];
    }
    return _titleLb;
}

- (ZDDInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ZDDInputView alloc] init];
        _inputView.textViewMaxLine = 4;
        __weak typeof(self)weakSelf = self;
        _inputView.sendBtnClickBlock = ^{
            [weakSelf sendComment];
        };
        _inputView.placeHolderString = @"这是一条高情商的评论~";
    }
    return _inputView;
}


-(UIView *)bgWhiteView {
    if (!_bgWhiteView) {
        _bgWhiteView = [[UIView alloc]init];
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        _bgWhiteView.layer.masksToBounds = YES;
    }
    return _bgWhiteView;
}
-(UIButton *)masking {
    if (!_masking) {
        _masking = [UIButton buttonWithType:UIButtonTypeCustom];
        [_masking addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_masking setBackgroundColor:[UIColor blackColor]];
        [_masking setAlpha:0.0f];
    }
    return _masking;
}

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii view:(UIView *)view{
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}

@end
