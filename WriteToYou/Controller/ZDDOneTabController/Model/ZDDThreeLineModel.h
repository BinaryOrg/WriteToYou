//
//  ZDDThreeLineModel.h
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThreeLineModel : NSObject

/** <#class#> */
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *autho;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger releaseTime;


@end

NS_ASSUME_NONNULL_END
