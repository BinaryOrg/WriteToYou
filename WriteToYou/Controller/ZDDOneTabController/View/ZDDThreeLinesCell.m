
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
//@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *likeAndCommentCountLb;


@end

@implementation ZDDThreeLinesCell

- (void)layoutSubviews {
    [self.contentView addSubview:self.contentLb];
    [self.contentView addSubview:self.authoLb];
    [self.contentView addSubview:self.likeAndCommentCountLb];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [self.authoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLb.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.contentLb.mas_right).mas_equalTo(-80);
    }];
    
    [self.likeAndCommentCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLb.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(self.authoLb.mas_right);
    }];
    
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor grayColor];
}


- (void)setModel:(ZDDThreeLineModel *)model {
    _model = model;
    self.contentLb.text = model.content;
    self.authoLb.text = [NSString stringWithFormat:@"------  %@", model.autho];
    self.likeAndCommentCountLb.text = [NSString stringWithFormat:@"%ld 喜欢 * %ld 评论", model.likeCount, model.commentCount];
}



- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _contentLb.textAlignment = NSTextAlignmentCenter;
        _contentLb.textColor = color(53, 64, 72, 1);
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}


- (UILabel *)authoLb {
    if (!_authoLb) {
        _authoLb = [[UILabel alloc] init];
        _authoLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _authoLb.textAlignment = NSTextAlignmentCenter;
        _authoLb.textColor = color(53, 64, 72, 1);
    }
    return _authoLb;
}


- (UILabel *)likeAndCommentCountLb {
    if (!_likeAndCommentCountLb) {
        _likeAndCommentCountLb = [[UILabel alloc] init];
        _likeAndCommentCountLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _likeAndCommentCountLb.textAlignment = NSTextAlignmentCenter;
        _likeAndCommentCountLb.textColor = color(53, 64, 72, 1);
        _likeAndCommentCountLb.textAlignment = NSTextAlignmentRight;
    }
    return _likeAndCommentCountLb;
}

@end
