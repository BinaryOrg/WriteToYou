//
//  TEMPBaseTabViewController.m
//  Template
//
//  Created by 张冬冬 on 2019/2/18.
//  Copyright © 2019 binary. All rights reserved.
//

#import "TEMPBaseTabViewController.h"
#import "UIColor+ZDDColor.h"
#import "ZDDThemeConfiguration.h"

@interface TEMPBaseTabViewController ()
<
UITabBarControllerDelegate
>
@end

@implementation TEMPBaseTabViewController

- (instancetype)initWithTabImageName:(nonnull NSString *)imageName
                   selectedImageName:(nonnull NSString *)selectedImageName
                               title:(nonnull NSString *)title {
    self = [super init];
    if (self) {
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
        ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.selectTabColor} forState:UIControlStateSelected];
        
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.normalTabColor} forState:UIControlStateNormal];
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
