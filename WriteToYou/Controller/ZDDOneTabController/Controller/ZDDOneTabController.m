//
//  ZDDOneTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDOneTabController.h"
#import "ZDDThreeLineCardView.h"
#import "ZDDSnowView.h"
#import "ZDDThreeLineCommentView.h"
#import "ZDDLogController.h"

@interface ZDDOneTabController () <ZDDThreeLineCardViewDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *postBtn;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ZDDThreeLineCardView *cardView;
@property (nonatomic, strong) ZDDSnowView *snowView;
@property (nonatomic, strong) ZDDThreeLineCommentView *commentView;


@end

@implementation ZDDOneTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
    
}

- (void)setupUI {
    
    self.snowView = [[ZDDSnowView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBARHEIGHT, self.view.frame.size.width, 40)];
    [self.view addSubview:self.snowView];
    
    [self.view addSubview:self.cardView];
    
    [self.view addSubview:self.postBtn];
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(- 35);
        make.bottom.mas_equalTo(self.cardView.mas_top).mas_equalTo(-20);
    }];
    
    [self.view addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cardView.mas_top).mas_equalTo(-20);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(- TABBARHEIGHT);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(51);
    }];
}


- (void)loadData {
    ZDDThreeLineModel *model = [[ZDDThreeLineModel alloc] init];
    model.content = @"螃蟹在剥我的壳，笔记本在写我 \n 漫天的我落在枫叶上雪花上 \n而你在想我";
    model.autho = @"Maker";
    model.likeCount = arc4random()%9999999;
    model.commentCount = arc4random()%9999999;
    
    ZDDThreeLineModel *model1 = [[ZDDThreeLineModel alloc] init];
    model1.content = @"从来不洗脸不漱口就去吃早饭\n那天你说你要来\n我洗了二块九毛七的澡";
    model1.autho = @"Maker";
    model1.likeCount = arc4random()%9999999;
    model1.commentCount = arc4random()%9999999;
    
    ZDDThreeLineModel *model2 = [[ZDDThreeLineModel alloc] init];
    model2.content = @"我想你 \n 我想睡你 \n我想睡醒有你";
    model2.autho = @"Maker";
    model2.likeCount = arc4random()%9999999;
    model2.commentCount = arc4random()%9999999;
    
    ZDDThreeLineModel *model3 = [[ZDDThreeLineModel alloc] init];
    model3.content = @"他们告诉我 女孩的心是水做的 \n 也难怪 \n我的爱 是横波啊";
    model3.autho = @"Maker";
    model3.likeCount = arc4random()%9999999;
    model3.commentCount = arc4random()%9999999;
    
    self.dataArray = @[model, model1, model2, model3];
    self.cardView.models = self.dataArray;
    
    self.titleLb.text = @"愿你一别心宽，再生欢喜";
}

//点击发布
- (void)clickPostBtn {
    if ([ZDDUserTool isLogin]) {
        
    }else {
        ZDDLogController *vc = [ZDDLogController new];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
    
    
}

//点击卡片
- (void)clickCardWithModel:(ZDDThreeLineModel *)model {
    [self.commentView showWithModel:model];
}


- (ZDDThreeLineCardView *)cardView {
    if (!_cardView) {
        _cardView = [[ZDDThreeLineCardView alloc] initWithFrame:CGRectMake(0, 150, SCREENWIDTH, SCREENHEIGHT - 150 - TABBARHEIGHT - 50)];
        _cardView.delegate = self;
    }
    return _cardView;
}

-(UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_postBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
        [_postBtn setShowsTouchWhenHighlighted:NO];
        [_postBtn addTarget:self action:@selector(clickPostBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = [UIColor grayColor];
    }
    return _titleLb;
}

- (ZDDThreeLineCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[ZDDThreeLineCommentView alloc] init];
    }
    return _commentView;
}

@end
