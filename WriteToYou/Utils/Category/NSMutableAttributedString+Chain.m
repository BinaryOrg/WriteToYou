//
//  NSMutableAttributedString+Chain.m
//  链式编程
//
//  Created by liuhao on 2017/5/26.
//  Copyright © 2017年 Lenhart. All rights reserved.
//

#import "NSMutableAttributedString+Chain.h"

@implementation NSMutableAttributedString (Chain)

+ (NSMutableAttributedString *)lh_makeAttributedString:(NSString *)string attributes:(void(^)(NSMutableDictionary *make))block {
    if (!string.length) return nil;
    NSMutableDictionary *make = [NSMutableDictionary dictionary];
    !block ? : block(make);
    if (string.length == 0) {
        string = @"";
    }
    return [[self alloc] initWithString:string attributes:make];
}

- (NSMutableAttributedString *)lh_addAttributedString:(NSString *)string attributes:(void(^)(NSMutableDictionary *make))block {
    NSMutableDictionary *make = [NSMutableDictionary dictionary];
    !block ? : block(make);
    if (string.length == 0) {
        string = @"";
    }
    [self appendAttributedString:[[NSMutableAttributedString alloc] initWithString:string attributes:make]];
    return self;
}

@end
