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
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *mobile_number;
@end

NS_ASSUME_NONNULL_END
