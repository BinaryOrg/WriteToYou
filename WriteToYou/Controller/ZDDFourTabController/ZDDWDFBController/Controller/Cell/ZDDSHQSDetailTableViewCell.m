//
//  ZDDSHQSDetailTableViewCell.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/26.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDSHQSDetailTableViewCell.h"
#import "UIColor+ZDDColor.h"
#import "TEMPMacro.h"
@implementation ZDDSHQSDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
        self.avatarImageView.layer.cornerRadius = 3;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
        self.nameLabel.textColor = [UIColor zdd_grayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.nameLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(self.avatarImageView.frame) + 15, 1.5, 20)];
        lineLabel.backgroundColor = [UIColor zdd_yellowColor];
        [self.contentView addSubview:lineLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, CGRectGetMaxY(self.avatarImageView.frame) + 5, 300, 40)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        self.dateLabel.textColor = [UIColor zdd_grayColor];
        
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.dateLabel.frame) + 5, SCREENWIDTH - 60, 0)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.summaryLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

@end
