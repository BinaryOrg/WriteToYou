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
#import "UIColor+ZDDColor.h"
@interface ZDDYZXSViewController ()
@property (nonatomic, strong) UIImageView *bottom_cover_book;
@property (nonatomic, strong) UIImageView *bottom_suture;
@property (nonatomic, strong) UIView *promptView;
@property (nonatomic, strong) UIImageView *top_cover_book;
@property (nonatomic, strong) UIImageView *cover_book;
@property (nonatomic, strong) UIImageView *cover_rope;
@property (nonatomic, strong) UIImageView *suture;
@property (nonatomic, strong) UIImageView *cover_stamp;
@property (nonatomic, strong) RQShineLabel *label;
@property (nonatomic, strong) RQShineLabel *promptLabel;
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
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(20, 30, 25, 25);
    [self.view addSubview:dismissButton];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage imageNamed:@"pro-ad-close_26x26_"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    dismissButton.tintColor = [UIColor zdd_grayColor];
    [dismissButton setImage:image forState:UIControlStateNormal];
    dismissButton.adjustsImageWhenHighlighted = NO;
    
    self.bottom_cover_book = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 267, 417)];
    self.bottom_cover_book.image = [UIImage imageNamed:@"cover_book_267x417_"];
    self.bottom_cover_book.center = self.view.center;
    [self.view addSubview:self.bottom_cover_book];
    self.bottom_cover_book.userInteractionEnabled = YES;
    
    self.bottom_suture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 260, 412)];
    [self.bottom_cover_book addSubview:self.bottom_suture];
    self.bottom_suture.userInteractionEnabled = YES;
    self.bottom_suture.image = [UIImage imageNamed:@"notebook_suture_260x412_"];

    self.promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 252, 393)];
    self.promptView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.promptView.frame = CGRectMake(3, 10, 251, 393);
    [self.bottom_cover_book addSubview:self.promptView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.promptView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.promptView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.promptView.layer.mask = maskLayer;
    
    
    self.promptLabel = [[RQShineLabel alloc] initWithFrame:self.promptView.bounds];
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = [UIColor grayColor];
    [self.promptView addSubview:self.promptLabel];
    self.promptLabel.shineDuration = 1.f;
    self.promptLabel.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeback = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick)];
    [self.promptView addGestureRecognizer:swipeback];
    
    self.top_cover_book = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 267, 417)];
    self.top_cover_book.userInteractionEnabled = YES;
    self.top_cover_book.image = [UIImage imageNamed:@"cover_book_267x417_"];
    [self.view addSubview:self.top_cover_book];
    self.top_cover_book.center = self.view.center;
    self.top_cover_book.userInteractionEnabled = YES;
    
    self.cover_book = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 267, 417)];
    self.cover_book.userInteractionEnabled = YES;
    self.cover_book.image = [UIImage imageNamed:@"cover_book_267x417_"];
    [self.top_cover_book addSubview:self.cover_book];
    
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
    self.label.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeforward = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClick)];
    [self.cover_book addGestureRecognizer:swipeforward];
    swipeforward.direction = UISwipeGestureRecognizerDirectionLeft;
    
//    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//    [self.cover_book addGestureRecognizer:swipeDown];
//    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self setAnchorPoint:CGPointMake(0, 0.5) forView:self.top_cover_book];
    [self setAnchorPoint:CGPointMake(0, 0.5) forView:self.promptView];
    
    self.top_cover_book.layer.transform = [self transform3D];
    self.promptView.layer.transform = [self transform3D];
    
    self.top_cover_book.layer.allowsEdgeAntialiasing = YES;
    self.promptView.layer.allowsEdgeAntialiasing = YES;
    
}

- (CATransform3D)transform3D {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.f / -2000;
    return transform;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonClick {
    [UIView animateWithDuration:0.8 animations:^{
        self.bottom_cover_book.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:1.f animations:^{
        self.top_cover_book.transform = CGAffineTransformIdentity;
    }];
    [self hide];
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};

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
        self.top_cover_book.layer.transform = CATransform3DMakeRotation(DegreesToRadians(-179), 0, 1, 0);
    }];
    [self show];
}

- (void)show {
    self.promptLabel.alpha = 1;
    self.promptLabel.text = @"是否需要打印情书\n并寄给您的意中人?\n我们帮您打印并包装好\n送到他(她)的手中！\n\n\n请联系微信：迟大雕";
    [self.promptLabel shine];
}

- (void)hide {
    [self.promptLabel fadeOut];
    [UIView animateWithDuration:0.7 animations:^{
        self.promptLabel.alpha = 0;
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
