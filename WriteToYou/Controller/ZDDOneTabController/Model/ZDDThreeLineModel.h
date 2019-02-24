//
//  ZDDThreeLineModel.h
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZDDDataModel.h"
#import "ZDDPoemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThreeLineModel : NSObject

@property (nonatomic, strong) ZDDUserModel *user;

@property (nonatomic, strong) ZDDPoemModel *poem;

@property (nonatomic, strong) NSArray <ZDDDataModel *> *comments;


@end



NS_ASSUME_NONNULL_END
