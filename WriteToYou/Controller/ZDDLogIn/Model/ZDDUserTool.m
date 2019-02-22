//
//  ZDDUserTool.m
//  WriteToYou
//
//  Created by Maker on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDUserTool.h"
#import "NSObject+YYModel.h"

#define GODUserPhoneKey @"userPhone"
#define GODUserTokenKey @"userToken"
#define GODUserInfoKey  @"userInfo"

@implementation ZDDUserTool

static ZDDUserTool *userTool = nil;

+ (ZDDUserTool *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userTool = [[self alloc] init];
        
        userTool.phone = [[NSUserDefaults standardUserDefaults] objectForKey:GODUserPhoneKey];
        
        // 取出字典, 转成模型后赋值
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:GODUserInfoKey];
        if (!dict) {
            return;
        }
        userTool.user = [ZDDUserModel yy_modelWithDictionary:dict];
        
    });
    return userTool;
}

/// 是否登陆
+ (BOOL)isLogin {
    return [ZDDUserTool shared].user.id.length ? YES : NO;
}

/// 清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GODUserTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:GODUserInfoKey];
    _user = nil;
    
}

#pragma mark - setter

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:GODUserPhoneKey];
}

- (void)setUser:(ZDDUserModel *)user {
    if (!user) {
        return;
    }
    
    _user = user;
    
    // 将模型转为json字典后, 存在本地
    NSDictionary *dict = [user yy_modelToJSONObject];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:GODUserInfoKey];
    
}
@end
