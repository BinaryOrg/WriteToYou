//
//  UIColor+ZDDColor.h
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZDDColor)
// default custom color
+ (UIColor *)zdd_grayColor;
+ (UIColor *)zdd_redColor;
+ (UIColor *)zdd_yellowColor;
+ (UIColor *)zdd_greenColor;
+ (UIColor *)zdd_blueColor;
+ (UIColor *)zdd_purpleColor;

//business custon color

- (BOOL)isDarkColor;
+ (UIColor *)zdd_colorWithRed:(NSUInteger)red
                        green:(NSUInteger)green
                         blue:(NSUInteger)blue;

+ (UIColor *)zdd_colorWithRed:(NSUInteger)red
                        green:(NSUInteger)green
                         blue:(NSUInteger)blue
                        alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
