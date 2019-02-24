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

@property (nonatomic, strong) NSArray<NSString *> *picture_path;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger last_update_date;
@property (nonatomic, assign) NSInteger star_num;
@property (nonatomic, assign) NSInteger comment_num;
@property (nonatomic, assign) BOOL is_star;
@end

NS_ASSUME_NONNULL_END
