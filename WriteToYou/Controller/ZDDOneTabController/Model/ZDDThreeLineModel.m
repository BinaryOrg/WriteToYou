//
//  ZDDThreeLineModel.m
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLineModel.h"

@implementation ZDDThreeLineModel



// 声明模型中的数组中的元素是模型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{
             @"comments" : [ZDDCommentModel class]
             };
}

@end
