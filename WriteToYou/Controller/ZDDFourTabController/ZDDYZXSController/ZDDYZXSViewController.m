//
//  ZDDYZXSViewController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDYZXSViewController.h"
#import "UIImage+Blur.h"
#import <RQShineLabel/RQShineLabel.h>

@interface ZDDYZXSViewController ()
@property (nonatomic, strong) UIImageView *bottom_cover_book;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UIImageView *cover_book;
@property (nonatomic, strong) UIImageView *cover_rope;
@property (nonatomic, strong) UIImageView *suture;
@property (nonatomic, strong) UIImageView *cover_stamp;
@property (nonatomic, strong) RQShineLabel *label;
@end

@implementation ZDDYZXSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.layer.masksToBounds = YES;
    bg.image = [[UIImage imageNamed:@"notebook_skin_default_261x464_"] blurredImage];
    bg.userInteractionEnabled = YES;
    [self.view addSubview:bg];
    
    self.bottom_cover_book = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 267, 417)];
    self.bottom_cover_book.image = [UIImage imageNamed:@"cover_book_267x417_"];
    self.bottom_cover_book.center = self.view.center;
    [self.view addSubview:self.bottom_cover_book];
    self.bottom_cover_book.userInteractionEnabled = YES;

    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 258, 393)];
    self.promptView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.promptView.frame = CGRectMake(3, 10, 255, 393);
    [self.bottom_cover_book addSubview:self.promptView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.promptView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.promptView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.promptView.layer.mask = maskLayer;
    
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.promptView addSubview:backButton];
    backButton.frame = self.promptView.bounds;
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.cover_book = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 267, 417)];
    self.cover_book.userInteractionEnabled = YES;
    self.cover_book.image = [UIImage imageNamed:@"cover_book_267x417_"];
    [self.view addSubview:self.cover_book];
    self.cover_book.center = self.view.center;
    
    self.suture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 260, 412)];
    [self.cover_book addSubview:self.suture];
    self.suture.userInteractionEnabled = YES;
    self.suture.image = [UIImage imageNamed:@"notebook_suture_260x412_"];
    
    self.cover_rope = [[UIImageView alloc] initWithFrame:CGRectMake(-1.5, 20, 270, 27)];
    self.cover_rope.image = [UIImage imageNamed:@"cover_rope_270x27_"];
    [self.cover_book addSubview:self.cover_rope];
    self.cover_rope.userInteractionEnabled = YES;
    
    self.cover_stamp = [[UIImageView alloc] initWithFrame:CGRectMake(58, 115, 151, 187)];
    self.cover_stamp.image = [UIImage imageNamed:@"cover_stamp_115x143_"];
    [self.cover_book addSubview:self.cover_stamp];
    self.cover_stamp.userInteractionEnabled = YES;
    
    self.label = [[RQShineLabel alloc] initWithFrame:self.cover_stamp.bounds];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor grayColor];
    [self.cover_stamp addSubview:self.label];
    self.label.shineDuration = 2.f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.label.bounds;
    self.label.userInteractionEnabled = YES;
    [self.label addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setAnchorPoint:CGPointMake(0, 0.5) forView:self.cover_book];
    self.cover_book.layer.transform = [self transform3D];
    
}

- (CATransform3D)transform3D {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}

- (void)backButtonClick {
    NSLog(@"123");
    [UIView animateWithDuration:0.8 animations:^{
        self.bottom_cover_book.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:1.f animations:^{
        self.cover_book.transform = CGAffineTransformIdentity;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _hideStautsBar];
    self.label.text = @"从前\n车马很慢\n书信很远\n一生\n只够爱一人";
    [self.label shine];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _showStatusBar];
}

- (void)buttonClick {
    [UIView animateWithDuration:0.8 animations:^{
        self.bottom_cover_book.transform = CGAffineTransformTranslate(self.bottom_cover_book.transform, -5, 0);
    }];
    [UIView animateWithDuration:1.f animations:^{
        self.cover_book.layer.transform = CATransform3DMakeRotation(-M_PI + 0.01, 0, 1, 0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_hideStautsBar {
    [UIView animateWithDuration:0.1 animations:^{
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        statusBar.alpha = 0;
    }];
}

- (void)_showStatusBar {
    [UIView animateWithDuration:0.1 animations:^{
        UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
        statusBar.alpha = 1;
    }];
}

- (void)setAnchorPoint:(CGPoint)point forView:(UIView *)view{
    view.frame = CGRectOffset(view.frame, (point.x - view.layer.anchorPoint.x) * view.frame.size.width, (point.y - view.layer.anchorPoint.y) * view.frame.size.height);
    view.layer.anchorPoint = point;
}

@end
