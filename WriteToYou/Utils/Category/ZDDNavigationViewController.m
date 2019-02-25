//
//  ZDDNavigationViewController.m
//  WriteToYou
//
//  Created by ZDD on 2019/2/25.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDNavigationViewController.h"

@interface ZDDNavigationViewController ()

@end

@implementation ZDDNavigationViewController

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}

@end
