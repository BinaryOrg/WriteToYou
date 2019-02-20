//
//  AppDelegate+BackgroundTask.h
//

/*
 * 应用进入后台仍可以启动一些后台任务, 如: 短信倒计时 etc.
 */
#import "TEMPAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TEMPAppDelegate (BackgroundTask)
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdenifier;
@end

NS_ASSUME_NONNULL_END
