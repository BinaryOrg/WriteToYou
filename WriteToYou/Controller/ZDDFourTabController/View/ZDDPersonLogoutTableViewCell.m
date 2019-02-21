//
//  ZDDPersonLogoutTableViewCell.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDPersonLogoutTableViewCell.h"
#import "TEMPMacro.h"
#import "UIColor+ZDDColor.h"
@implementation ZDDPersonLogoutTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.funcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 46)];
        self.funcLabel.text = @"退出登录";
        self.funcLabel.textColor = [UIColor zdd_redColor];
        self.funcLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.funcLabel];
    }
    return self;
}

@end
