//
//  ZDDOneTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDOneTabController.h"
#import "ZDDThreeLinesCell.h"

@interface ZDDOneTabController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZDDOneTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
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
    [self.collectionView reloadData];
}


#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDDThreeLinesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZDDThreeLinesCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREENWIDTH - 40, SCREENHEIGHT - 150);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZDDThreeLinesCell class] forCellWithReuseIdentifier:@"ZDDThreeLinesCell"];
    }
    return _collectionView;
}

@end
