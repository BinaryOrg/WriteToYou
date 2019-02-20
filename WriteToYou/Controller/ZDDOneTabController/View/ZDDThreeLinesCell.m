
//
//  ZDDThreeLinesCell.m
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLinesCell.h"

@interface ZDDThreeLinesCell ()

@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *authoLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *likeAndCommentCountLb;


@end

@implementation ZDDThreeLinesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
