//
//  ZDDThreeLineCardView.m
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLineCardView.h"
#import "ZDDThreeLinesCell.h"

NSString *const CellIdentifier = @"CellIdentifier";

CGFloat const HorizontalMargin = 20.0f;
CGFloat const ItemMargin = 10.0;

@interface ZDDThreeLineCardView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIScrollView *panScrollView;

@property(nonatomic, assign, getter=isMultiplePages) BOOL multiplePage;

@end

@implementation ZDDThreeLineCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    CGFloat collectionViewWidth = self.frame.size.width;
    CGFloat collectionViewHeight = self.frame.size.height;
    CGFloat itemWidth = collectionViewWidth - HorizontalMargin * 2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWidth, collectionViewHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = ItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, HorizontalMargin, 0, HorizontalMargin);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionViewWidth, collectionViewHeight) collectionViewLayout:layout];
    [self addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.clipsToBounds = NO;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[ZDDThreeLinesCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    CGFloat pageScrollWidth = itemWidth + ItemMargin;
    _panScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((collectionView.frame.size.width - pageScrollWidth)/2, 0, pageScrollWidth, collectionViewHeight)];
    
    [self addSubview:_panScrollView];
    _panScrollView.hidden = YES;
    _panScrollView.showsHorizontalScrollIndicator = NO;
    _panScrollView.alwaysBounceHorizontal = YES;
    _panScrollView.pagingEnabled = YES;
    _panScrollView.delegate = self;
    
    [_collectionView addGestureRecognizer:_panScrollView.panGestureRecognizer];
    _collectionView.panGestureRecognizer.enabled = NO;
}

- (void)setModels:(NSArray<ZDDThreeLineModel *> *)models {
    _models = models;
    [self updateView];
}

- (void)updateView {
    [_collectionView reloadData];
}

- (void)autoScroll {
    if (_models.count <= 1) {
        return;
    }
    
    // 滚到最后一页的时候，回到第一页
    if (_panScrollView.contentOffset.x >= _panScrollView.frame.size.width * (_models.count - 1)) {
        [_panScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [_panScrollView setContentOffset:CGPointMake(_panScrollView.contentOffset.x + _panScrollView.frame.size.width, 0) animated:YES];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    _panScrollView.contentSize = CGSizeMake(_panScrollView.frame.size.width * _models.count, 0);
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZDDThreeLinesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item < _models.count) {
        cell.model = _models[indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(clickCardWithModel:)] && indexPath.item < _models.count) {
        [self.delegate clickCardWithModel:_models[indexPath.item]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _panScrollView) {
        _collectionView.contentOffset = _panScrollView.contentOffset;
    }
}

- (void)dealloc {
    self.delegate = nil;
}
@end
