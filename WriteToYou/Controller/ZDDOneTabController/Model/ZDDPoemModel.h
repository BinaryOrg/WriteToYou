//
//  ZDDPoemModel.h
//  WriteToYou
//
//  Created by Maker on 2019/2/24.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDPoemModel : NSObject

@property (nonatomic, strong) NSString *poem_id;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *picture_path;
@property (nonatomic, strong) NSString *last_update_date;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) NSInteger star_num;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) NSInteger is_star;
@end

NS_ASSUME_NONNULL_END
