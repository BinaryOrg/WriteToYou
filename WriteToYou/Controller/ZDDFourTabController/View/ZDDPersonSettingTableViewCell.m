//
//  ZDDPersonSettingTableViewCell.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDPersonSettingTableViewCell.h"
#import "TEMPMacro.h"
@implementation ZDDPersonSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.funcLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 100, 46)];
        [self.contentView addSubview:self.funcLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
