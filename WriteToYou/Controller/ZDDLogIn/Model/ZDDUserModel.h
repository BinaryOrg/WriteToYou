//
//  ZDDUserModel.h
//  WriteToYou
//
//  Created by Maker on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDUserModel : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phone;
@end

NS_ASSUME_NONNULL_END
