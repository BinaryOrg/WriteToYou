//
//  ZDDPostThreeLineController.m
//  WriteToYou
//
//  Created by Maker on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDPostThreeLineController.h"

@interface ZDDPostThreeLineController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIImageView *sendImgeView;
@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation ZDDPostThreeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    
    [self.view addSubview:self.contentTextView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.sendImgeView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-2);;
        make.top.mas_equalTo(120);
        make.bottom.mas_equalTo(-150);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.contentTextView.mas_top).mas_equalTo(15);
    }];

    [self.sendImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.contentTextView.mas_top).mas_equalTo(15);
    }];

}

- (void)leftBarButtonItemDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font =  [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:15];
        _contentTextView.layer.cornerRadius = 10;
        _contentTextView.layer.masksToBounds = YES;
        _contentTextView.textAlignment = NSTextAlignmentCenter;
    }
    return _contentTextView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        // 左边返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(leftBarButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = backButton;
    }
    return _backBtn;
}

- (UIImageView *)sendImgeViewv {
    if (!_sendImgeView) {
        _sendImgeView = [[UIImageView alloc] init];
        _sendImgeView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImgeView.image = [UIImage imageNamed:@""];
    }
    return _sendImgeView;
}


@end
