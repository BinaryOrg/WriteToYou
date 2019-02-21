//
//  ZDDFourTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDFourTabController.h"
#import "ZDDYZXSViewController.h"
@interface ZDDFourTabController ()

@end

@implementation ZDDFourTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.navigationController pushViewController:[ZDDYZXSViewController new] animated:YES];
    [self presentViewController:[ZDDYZXSViewController new] animated:YES completion:nil];
}

@end
