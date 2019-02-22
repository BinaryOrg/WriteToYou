//
//  NSString+Regex.m
//  小灯塔
//
//  Created by Maker on 2018/4/13.
//  Copyright © 2018年 Maker. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

/**
 *  得到中英文混合字符串长度
 */
- (NSInteger)getToInt {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:enc];
    return [data length];
}

/**
 *  正则判断是否是 手机号 11位1开头的阿拉伯数字
 */
- (BOOL)isMobileNumber {
    if ((self.length <= 11) &&(5<=self.length) && [self isNumber]) {
        return YES;
    }
    return NO;
//
//    if (![self hasPrefix:@"1"] || self.length != 11 || ![self isNumber]) {
//        return NO;
//    }
//    return YES;
}


/**
 *  正则判断是否是 纯数字
 */
- (BOOL)isNumber {
    NSString * regex = @"[0-9]*";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/**
 *  正则判断是否是 微信格式 微信号需为4-24个英文字母或数字
 */
- (BOOL)isWeChatNumber {
    NSString *MOBILE = @"^[a-zA-Z0-9_-]{4,24}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:self];
}

@end
