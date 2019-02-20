//
//  ZDDThemeConfiguration.m
//  Template
//
//  Created by 张冬冬 on 2019/2/18.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThemeConfiguration.h"
#import "UIColor+ZDDColor.h"
@implementation ZDDThemeConfiguration

+ (instancetype)defaultConfiguration {
    static dispatch_once_t onceToken;
    static ZDDThemeConfiguration *config = nil;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

/*
 
 + (UIColor *)naviTintColor {
 return [UIColor blackColor];
 }
 
 + (UIColor *)selectTabColor {
 return [self zdd_blueColor];
 }
 
 + (UIColor *)normalTabColor {
 return [self zdd_grayColor];
 }
 
 + (UIColor *)themeColor {
 return [UIColor whiteColor];
 }
 
 */

- (UIColor *)themeColor {
    if (!_themeColor) {
        _themeColor = [UIColor whiteColor];
    }
    return _themeColor;
}

- (UIColor *)selectTabColor {
    if (!_selectTabColor) {
        BOOL isDark = [[self themeColor] isDarkColor];
        _selectTabColor = isDark ? [UIColor whiteColor] : [UIColor zdd_blueColor];
    }
    return _selectTabColor;
}

- (UIColor *)normalTabColor {
    if (!_normalTabColor) {
        _normalTabColor = [UIColor zdd_grayColor];
    }
    return _normalTabColor;
}

- (UIColor *)naviTintColor {
    if (!_naviTintColor) {
        BOOL isDark = [[self themeColor] isDarkColor];
        _naviTintColor = isDark ? [UIColor whiteColor] : [UIColor zdd_grayColor];
    }
    return _naviTintColor;
}

- (UIColor *)naviTitleColor {
    if (!_naviTitleColor) {
        BOOL isDark = [[self themeColor] isDarkColor];
        _naviTitleColor = isDark ? [UIColor whiteColor] : [UIColor zdd_grayColor];
    }
    return _naviTitleColor;
}

- (UIColor *)addButtonColor {
    if (!_addButtonColor) {
        BOOL isDark = [[self themeColor] isDarkColor];
        _addButtonColor = isDark ? [UIColor whiteColor] : [UIColor zdd_grayColor];
    }
    return _addButtonColor;
}

@end
