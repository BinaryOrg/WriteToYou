//
//  AppDelegate+BackgroundTask.m
//

#import "TEMPAppDelegate+BackgroundTask.h"
#import <objc/runtime.h>
#import <Bugly/Bugly/Bugly.h>
#import <AVFoundation/AVFoundation.h>
#import "TEMPMacro.h"

@implementation TEMPAppDelegate (BackgroundTask)

void uncaughtExceptionHandler(NSException *exception) {
    [Bugly reportException:exception];
}

- (void)setCount:(NSInteger)count {
    objc_setAssociatedObject(self, @selector(count), @(count), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)count {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBackgroundTaskIdenifier:(UIBackgroundTaskIdentifier)backgroundTaskIdenifier {
    objc_setAssociatedObject(self, @selector(backgroundTaskIdenifier), @(backgroundTaskIdenifier), OBJC_ASSOCIATION_ASSIGN);
}

- (UIBackgroundTaskIdentifier)backgroundTaskIdenifier {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.count ++;
        }];
    }
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self beginTask];
}

- (void)beginTask {
    self.backgroundTaskIdenifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endTask];
    }];
}

- (void)endTask {
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdenifier];
    self.backgroundTaskIdenifier = UIBackgroundTaskInvalid;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endTask];
}

/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // *让 app 接受远程事件控制，及锁屏是控制版会出现播放按钮
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    // *后台播放代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
@end
