//
//  ZDDOneTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDOneTabController.h"
#import "ZDDThreeLineCardView.h"

@interface ZDDOneTabController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ZDDThreeLineCardView *cardView;

@end

@implementation ZDDOneTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.cardView];
    [self loadData];
    
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
}


- (ZDDThreeLineCardView *)cardView {
    if (!_cardView) {
        _cardView = [[ZDDThreeLineCardView alloc] initWithFrame:CGRectMake(0, 150, SCREENWIDTH, SCREENHEIGHT - 150 - TABBARHEIGHT - 50)];
    }
    return _cardView;
}

@end
