//
//  ZDDCommentModel.h
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDCommentModel : NSObject


/** <#class#> */
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *poem_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger create_date;
@property (nonatomic, strong) NSString *last_update_date;


@end

NS_ASSUME_NONNULL_END
