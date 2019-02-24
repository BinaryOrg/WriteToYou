//
//  ZDDQR0TableViewCell.m
//  WriteToYou
//
//  Created by ZDD on 2019/2/24.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDQR0TableViewCell.h"
#import "UIColor+ZDDColor.h"
#import "TEMPMacro.h"
@implementation ZDDQR0TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 20, 1.5, 20)];
        lineLabel.backgroundColor = [UIColor zdd_yellowColor];
        [self.contentView addSubview:lineLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 300, 40)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:17];
        self.dateLabel.textColor = [UIColor zdd_grayColor];
        
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.dateLabel.frame), SCREENWIDTH - 60, 50)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView1.userInteractionEnabled = YES;
        
        
        self.commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 135, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.commentImageView.image = [UIImage imageNamed:@"ic_messages_comment_20x20_"];
        [self.contentView addSubview:self.commentImageView];
        self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentImageView.frame), CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.commentCountLabel];
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentCountLabel.frame) + 5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        [self.contentView addSubview:self.likeImageView];
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImageView.frame), CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.likeCountLabel];
        
    }
    return self;
}

@end
