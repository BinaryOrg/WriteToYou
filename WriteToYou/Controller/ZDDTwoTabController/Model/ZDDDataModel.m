//
//  ZDDDataModel.m
//  WriteToYou
//
//  Created by ZDD on 2019/2/24.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDDataModel.h"

@implementation ZDDDataModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"poem" : @[@"poem", @"comment"],
             };
}

@end
