//
//  ZDDDataModel.h
//  WriteToYou
//
//  Created by ZDD on 2019/2/24.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "ZDDUserModel.h"
#import "ZDDQRModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZDDDataModel : NSObject
@property (nonatomic, strong) ZDDUserModel *user;
@property (nonatomic, strong) ZDDQRModel *poem;
@end

NS_ASSUME_NONNULL_END
