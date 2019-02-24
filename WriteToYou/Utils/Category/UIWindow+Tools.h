//
//  UIWindow+Tools.h
//  MakeupScret
//
//  Created by HzB on 16/3/23.
//  Copyright © 2016年 维他命-妆秘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Tools)


/**
 * 获取最上层的UIViewController
 * @return topViewController 最上层的UIViewController
 */
+ (UIViewController *)topViewController;

/**
 * 获取当前的UIWindow
 * @return currentWindow 当前使用的UIWindow
 */
+ (UIWindow *)currentWindow;

@end
