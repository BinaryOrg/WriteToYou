//
//  ZDDWDFBViewController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDWDFBViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "ZDDThemeConfiguration.h"
#import "ZDDWDTwoViewController.h"
#import "ZDDWDOneViewController.h"

#import "UIColor+ZDDColor.h"
@interface ZDDWDFBViewController ()
<
JXCategoryListContainerViewDelegate,
JXCategoryViewDelegate
>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView  *listContainerView;
@end

@implementation ZDDWDFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, STATUSBARANDNAVIGATIONBARHEIGHT, SCREENWIDTH, 50)];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    self.categoryView.delegate = self;
    self.categoryView.titleColor = [UIColor zdd_grayColor];
    self.categoryView.titleSelectedColor = theme.selectTabColor;
    [self.view addSubview:self.categoryView];
    self.categoryView.titles = @[@"三行情书", @"写给前任"];
    self.categoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    
    lineView.indicatorLineViewColor = theme.selectTabColor;
    lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    [self.view addSubview:self.listContainerView];
    //关联cotentScrollView，关联之后才可以互相联动！！！
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.categoryView.frame = CGRectMake(0, STATUSBARANDNAVIGATIONBARHEIGHT, self.view.bounds.size.width, 50);
    self.listContainerView.frame = CGRectMake(0, STATUSBARANDNAVIGATIONBARHEIGHT + 50, self.view.bounds.size.width, self.view.bounds.size.height - 50 - STATUSBARANDNAVIGATIONBARHEIGHT);
}

//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}
//返回遵从`JXCategoryListContentViewDelegate`协议的实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (!index) {
        ZDDWDOneViewController *vc = [[ZDDWDOneViewController alloc] init];
        vc.naviController = self.navigationController;
        return vc;
    }
    ZDDWDTwoViewController *vc = [[ZDDWDTwoViewController alloc] init];
    vc.naviController = self.navigationController;
    return vc;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

@end
