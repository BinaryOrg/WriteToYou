//
//  TEMPLaunchManager.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "TEMPLaunchManager.h"
#import "UIColor+ZDDColor.h"

#import "ZDDThemeConfiguration.h"
#import "ZDDTabBarController.h"

@implementation TEMPLaunchManager
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static TEMPLaunchManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)launchInWindow:(UIWindow *)window {
    
    MFNETWROK.baseURL = BASE_URL;

    
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    
    //    只需要在这里修改如下5个主题颜色即可，注意颜色搭配和理性:
    theme.naviTitleColor = [UIColor blackColor];
    theme.naviTintColor = [UIColor blackColor];
    //    theme.themeColor =
    theme.normalTabColor = [UIColor blackColor];
    theme.selectTabColor = [UIColor zdd_yellowColor];
    theme.addButtonColor = [UIColor whiteColor];
    //NavigationBar 和 TabBar 偏好设置
    NSDictionary *dict = [NSDictionary dictionaryWithObject:theme.naviTitleColor forKey:NSForegroundColorAttributeName];
    [UINavigationBar appearance].titleTextAttributes = dict;
    [[UINavigationBar appearance] setTintColor:theme.naviTintColor];
    [[UINavigationBar appearance] setBarTintColor:theme.themeColor];
    [[UITabBar appearance] setBarTintColor:theme.themeColor];
    [[UITabBar appearance] setTintColor:theme.selectTabColor];
    [[UITabBar appearance] setUnselectedItemTintColor:theme.normalTabColor];
    BOOL isDark = [theme.themeColor isDarkColor];
    [UIApplication sharedApplication].statusBarStyle = isDark ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    ZDDTabBarController *tabBarController = [[ZDDTabBarController alloc] initWithCenterButton:NO];
    window.rootViewController = tabBarController;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
}
@end
