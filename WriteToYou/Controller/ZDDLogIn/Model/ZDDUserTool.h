//
//  ZDDUserTool.h
//  WriteToYou
//
//  Created by Maker on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDDUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDUserTool : NSObject
+ (ZDDUserTool *)shared;
/** 是否登陆 */
+ (BOOL)isLogin;

/** 用户信息类 */
@property (nonatomic, strong) ZDDUserModel *user;
/** 用户的手机号码 */
@property (nonatomic, strong) NSString *phone;
/**
 清除用户信息的方法, 如果有手机号码, 手机号码保留不清除
 */
- (void)clearUserInfo;
@end

NS_ASSUME_NONNULL_END
