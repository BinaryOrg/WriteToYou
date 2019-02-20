//
//  ZTWAppDelegate+PushService.m
//  ZhiYun
//
//  Created by 张冬冬 on 2019/2/12.
//  Copyright © 2019 张冬冬. All rights reserved.
//

#import "TEMPAppDelegate+PushService.h"

#import <JPush/JPUSHService.h>
@implementation TEMPAppDelegate (PushService)

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

@end
