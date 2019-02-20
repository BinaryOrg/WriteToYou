//
//  ZDDTabBarController.m
//  Template
//
//  Created by 张冬冬 on 2019/2/19.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDTabBarController.h"
#import "ZDDThemeConfiguration.h"
#import "TEMPMacro.h"

#import "ZDDOneTabController.h"
#import "ZDDTwoTabController.h"
#import "ZDDThreeTabController.h"
#import "ZDDFourTabController.h"

@interface ZDDTabBarController ()
<
UITabBarControllerDelegate
>
@property (nonatomic, assign) BOOL hasCenterButton;
@end

@implementation ZDDTabBarController

- (instancetype)initWithCenterButton:(BOOL)hasCenterButton {
    _hasCenterButton = hasCenterButton;
    self = [super init];
    if (self) {
        ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.selectTabColor} forState:UIControlStateSelected];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.normalTabColor} forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildViewControllers];
    self.delegate = self;
    if (self.hasCenterButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBar addSubview:addButton];
        addButton.frame = CGRectMake((SCREENWIDTH - 45)/2.0, 5, 45, HEIGHT(self.tabBar) - 20);
        UIImage *image = [[UIImage imageNamed:@"tab_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [addButton setImage:image forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.adjustsImageWhenDisabled = NO;
        addButton.adjustsImageWhenHighlighted = NO;
        ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
        addButton.backgroundColor = theme.selectTabColor;
        addButton.tintColor = theme.addButtonColor;
    }
}

- (void)addButtonClick {
    NSLog(@"%@", @"fuck");
}

- (void)setupChildViewControllers {
    ZDDOneTabController *one = [[ZDDOneTabController alloc] initWithTabImageName:@"tab_now_nor"
                                                               selectedImageName:@"tab_now_press"
                                                                           title:@"G"];
    ZDDTwoTabController *two = [[ZDDTwoTabController alloc] initWithTabImageName:@"tab_see_nor"
                                                               selectedImageName:@"tab_see_press"
                                                                           title:@"O"];
    ZDDThreeTabController *three = [[ZDDThreeTabController alloc] initWithTabImageName:@"tab_qworld_nor"
                                                                     selectedImageName:@"tab_qworld_press"
                                                                                 title:@"D"];
    ZDDFourTabController *four = [[ZDDFourTabController alloc] initWithTabImageName:@"tab_recent_nor"
                                                                  selectedImageName:@"tab_recent_press"
                                                                              title:@"Z"];
    
    UINavigationController *n1 = [[UINavigationController alloc] initWithRootViewController:one];
    UINavigationController *n2 = [[UINavigationController alloc] initWithRootViewController:two];
    UINavigationController *n3 = [[UINavigationController alloc] initWithRootViewController:three];
    UINavigationController *n4 = [[UINavigationController alloc] initWithRootViewController:four];
    
    [self addChildViewController:n1];
    [self addChildViewController:n2];
    if (self.hasCenterButton) {
        UIViewController *center = [[UIViewController alloc] init];
        [self addChildViewController:center];
    }
    [self addChildViewController:n3];
    [self addChildViewController:n4];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //点击发布
    if ([tabBarController.viewControllers objectAtIndex:2] == viewController) {
        if (self.hasCenterButton) {
            [self addButtonClick];
            return NO;
        }
        return NO;
    }
    return YES;
}

@end
