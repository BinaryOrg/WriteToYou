//
//  ZDDThemeConfiguration.h
//  Template
//
//  Created by 张冬冬 on 2019/2/18.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
/*
 + (UIColor *)themeColor;
 + (UIColor *)normalTabColor;
 + (UIColor *)selectTabColor;
 + (UIColor *)naviTintColor;
 */
@interface ZDDThemeConfiguration : NSObject
+ (instancetype)defaultConfiguration;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *normalTabColor;
@property (nonatomic, strong) UIColor *selectTabColor;
@property (nonatomic, strong) UIColor *naviTintColor;
@property (nonatomic, strong) UIColor *naviTitleColor;
@property (nonatomic, strong) UIColor *addButtonColor;
@end

NS_ASSUME_NONNULL_END
