
//
//  ZDDThreeLinesCell.m
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLinesCell.h"
#import "UIWindow+Tools.h"
#import "ZDDLogController.h"

@interface ZDDThreeLinesCell ()

@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *authoLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *likeAndCommentCountLb;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *likeImageView;


@end

@implementation ZDDThreeLinesCell

- (void)layoutSubviews {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.timeLb];
    [self.contentView addSubview:self.contentLb];
    [self.contentView addSubview:self.authoLb];
    [self.contentView addSubview:self.likeAndCommentCountLb];
    [self.contentView addSubview:self.likeImageView];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-20);
    }];
    
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [self.authoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLb.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-20);
    }];
    
    [self.likeAndCommentCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authoLb.mas_bottom).mas_equalTo(8);
        make.right.mas_equalTo(-20);
    }];
    
    [self.likeAndCommentCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authoLb.mas_bottom).mas_equalTo(8);
        make.right.mas_equalTo(-20);
    }];
    
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- 40);
        make.right.mas_equalTo(-40);
    }];
  
    
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor grayColor];
}


- (void)setModel:(ZDDThreeLineModel *)model {
    _model = model;
    self.contentLb.text = model.poem.content;
    self.authoLb.text = [NSString stringWithFormat:@"---  %@", model.user.user_name];
    self.likeAndCommentCountLb.text = [NSString stringWithFormat:@"%ld 喜欢 · %ld 评论", model.poem.star_num, model.poem.comment_num];
    
    NSDate *sinceDate = [NSDate dateWithTimeIntervalSince1970:model.poem.create_date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [formatter setDateFormat:@"yyyy / MM / dd"];
    NSString *createdAtString  = [formatter stringFromDate:sinceDate];
    self.timeLb.text = createdAtString;

    self.imgView.image = [UIImage imageNamed:@"bgv_9"/**[NSString stringWithFormat:@"bgv_%u", arc4random()%11]*/];
    [self reloadLikeView];
}

- (void)reloadLikeView {
    if (self.model.poem.is_star) {
        self.likeImageView.image = [UIImage imageNamed:@"like"];
        [self heartAnimation];
    }else {
        [self stopHeartAnimation];
        self.likeImageView.image = [UIImage imageNamed:@"dislike"];
    }
    
}

- (void)heartAnimation{
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.toValue = @0.5;
    anima.repeatCount = MAXFLOAT;
    anima.duration = 0.3;
    anima.autoreverses = YES;
    [self.likeImageView.layer addAnimation:anima forKey:@"shake"];
}


- (void)stopHeartAnimation{
    if ([self.likeImageView.layer animationForKey:@"shake"]) {
        [self.likeImageView.layer removeAllAnimations];
    }
}

- (void)clickLike {
    if ([ZDDUserTool isLogin]) {
        self.model.poem.is_star = !self.model.poem.is_star;
        [self reloadLikeView];
        if ([self.delegate respondsToSelector:@selector(clickStar:withModel:)]) {
            [self.delegate clickStar:self.model.poem.is_star withModel:self.model];
        }
    }else {
   
        ZDDLogController *vc = [ZDDLogController new];
        
        [[UIWindow topViewController] presentViewController:vc animated:YES completion:nil] ;
    }
}

- (void)dealloc {
    self.delegate = nil;
}

- (UILabel *)contentLb {
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.font = [UIFont fontWithName:@"American Typewriter" size:16];
        _contentLb.textAlignment = NSTextAlignmentCenter;
        _contentLb.textColor = [UIColor whiteColor];
        _contentLb.numberOfLines = 0;
    }
    return _contentLb;
}


- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        _timeLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.textColor = [UIColor grayColor];
    }
    return _timeLb;
}

- (UILabel *)authoLb {
    if (!_authoLb) {
        _authoLb = [[UILabel alloc] init];
        _authoLb.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _authoLb.textAlignment = NSTextAlignmentRight;
        _authoLb.textColor = [UIColor grayColor];
    }
    return _authoLb;
}


- (UILabel *)likeAndCommentCountLb {
    if (!_likeAndCommentCountLb) {
        _likeAndCommentCountLb = [[UILabel alloc] init];
        _likeAndCommentCountLb.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        _likeAndCommentCountLb.textColor = [UIColor grayColor];
        _likeAndCommentCountLb.textAlignment = NSTextAlignmentRight;
    }
    return _likeAndCommentCountLb;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UIImageView *)likeImageView {
    if (!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _likeImageView.userInteractionEnabled = YES;
        [_likeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLike)]];
    }
    return _likeImageView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = color(0, 0, 0, 0.15);
    }
    return _coverView;
}


@end
