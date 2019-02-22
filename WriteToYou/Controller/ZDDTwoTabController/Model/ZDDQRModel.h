//
//  ZDDQRModel.h
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDQRModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *pics;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, assign) BOOL liked;
@end

NS_ASSUME_NONNULL_END
