//
//  ZDDQR2TableViewCell.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDQR2TableViewCell.h"
#import "UIColor+ZDDColor.h"
#import "TEMPMacro.h"
@implementation ZDDQR2TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 20, 1.5, 20)];
        lineLabel.backgroundColor = [UIColor zdd_yellowColor];
        [self.contentView addSubview:lineLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 300, 40)];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.font = [UIFont systemFontOfSize:20];
        self.dateLabel.textColor = [UIColor zdd_grayColor];
        
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.dateLabel.frame), (SCREENWIDTH - 80)/2, ((SCREENWIDTH - 80)/2))];
        self.imageView1.layer.cornerRadius = 7;
        self.imageView1.layer.masksToBounds = YES;
        self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView1];
        
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView1.frame) + 20, CGRectGetMaxY(self.dateLabel.frame), (SCREENWIDTH - 80)/2, ((SCREENWIDTH - 80)/2))];
        self.imageView2.layer.cornerRadius = 7;
        self.imageView2.layer.masksToBounds = YES;
        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView2];
        
        self.summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.imageView2.frame) + 5, SCREENWIDTH - 60, 50)];
        self.summaryLabel.numberOfLines = 0;
        self.summaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.summaryLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView1.userInteractionEnabled = YES;
        self.imageView2.userInteractionEnabled = YES;
        
        self.commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 135, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.commentImageView.image = [UIImage imageNamed:@"ic_messages_comment_20x20_"];
        [self.contentView addSubview:self.commentImageView];
        self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentImageView.frame)+5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.commentCountLabel];
        self.likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentCountLabel.frame) + 5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 20, 20)];
        self.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        [self.contentView addSubview:self.likeImageView];
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeImageView.frame)+5, CGRectGetMaxY(self.summaryLabel.frame) + 5, 30, 20)];
        [self.contentView addSubview:self.likeCountLabel];
        
        self.likeCountLabel.textColor = [UIColor zdd_grayColor];
        self.commentCountLabel.textColor = [UIColor zdd_grayColor];
    }
    return self;
}


@end
