//
//  UIColor+ZDDColor.m
//  

#import "UIColor+ZDDColor.h"

@implementation UIColor (ZDDColor)

- (BOOL)isDarkColor {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    CGFloat lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    if (lum < .5) {
        return YES;
    }
    return NO;
}

+ (UIColor *)zdd_grayColor {
    return [self zdd_colorWithRed:140 green:140 blue:140];
}

+ (UIColor *)zdd_redColor {
    return [self zdd_colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)zdd_yellowColor {
    return [self zdd_colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)zdd_greenColor {
    return [self zdd_colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)zdd_blueColor {
    return [self zdd_colorWithRed:52 green:152 blue:219];
}

+ (UIColor *)zdd_purpleColor {
    return [self zdd_colorWithRed:68 green:87 blue:169];
}

+ (UIColor *)zdd_colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue {
    
    return [self zdd_colorWithRed:red green:green blue:blue alpha:1.f];
}

+ (UIColor *)zdd_colorWithRed:(NSUInteger)red
                       green:(NSUInteger)green
                        blue:(NSUInteger)blue
                       alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:alpha];
}


@end
