//
//  UIWindow+Tools.m
//  MakeupScret
//
//  Created by HzB on 16/3/23.
//  Copyright © 2016年 维他命-妆秘. All rights reserved.
//

#import "UIWindow+Tools.h"

/**
 *  取到最上层的控制器 进行 跳转
 */

@implementation UIWindow (Tools)

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#pragma mark instance method
- (UIViewController *)topViewController{
    UIViewController *rootViewController = self.rootViewController;
    return [UIWindow getVisibleViewControllerFrom:rootViewController];
}
#pragma mark class method
+ (UIViewController *)topViewController{
    return [[self currentWindow] topViewController];
}
+ (UIWindow *)currentWindow{
    return [[[UIApplication sharedApplication] delegate] window];
}

@end
