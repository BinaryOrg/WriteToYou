//
//  ZDDCommentTableViewCell.m
//  WriteToYou
//
//  Created by ZDD on 2019/2/24.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDCommentTableViewCell.h"
#import "UIColor+ZDDColor.h"
#import "TEMPMacro.h"
@implementation ZDDCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        self.avatarImageView.layer.cornerRadius = 5;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 30)];
        self.nameLabel.textColor = [UIColor zdd_grayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(self.summaryLabel.frame), 300, 20)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        self.dateLabel.textColor = [UIColor zdd_grayColor];
        
        
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(self.nameLabel.frame), SCREENWIDTH - 80 - 20, 0)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.summaryLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
}

@end
