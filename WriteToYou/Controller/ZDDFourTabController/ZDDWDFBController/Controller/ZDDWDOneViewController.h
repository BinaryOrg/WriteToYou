//
//  ZDDWDOneViewController.h
//  WriteToYou
//
//  Created by ZDD on 2019/2/25.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDWDOneViewController : UIViewController
<
JXCategoryListContentViewDelegate
>
@property (nonatomic, strong) UINavigationController *naviController;
@end

NS_ASSUME_NONNULL_END
