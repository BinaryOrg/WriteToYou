//
//  MODropAlertView.m
//  MODropAlertDemo
//
//  Created by Ahn JungMin on 2014. 7. 1..
//  Copyright (c) 2014년 Ahn JungMin. All rights reserved.
//

#import "MODropAlertView.h"
#import "UIImage+ImageEffects.h"

static const CGFloat kAlertButtonBottomMargin = 10;
static const CGFloat kAlertButtonSideMargin = 15;
static const CGFloat kAlertButtonsBetweenMargin = 3;
static const CGFloat kAlertButtonHeight = 60;

static const CGFloat kAlertTitleLabelHeight = 30;
static const CGFloat kAlertTitleLabelTopMargin = 30;
//static const CGFloat kALertdescriptionViewTopMargin = 50;
static const CGFloat kAlertdescriptionViewHeight = 50;

static const CGFloat kAlertTitleLabelFontSize = 24;
//static const CGFloat kAlertdescriptionViewFontSize = 16;
static const CGFloat kAlertButtonFontSize = 14;

static NSString* kAlertOKButtonNormalColor = @"#5677fc";
static NSString* kAlertOKButtonHighlightColor = @"#2a36b1";
static NSString* kAlertCancelButtonNormalColor = @"#e51c23";
static NSString* kAlertCancelButtonHighlightColor = @"#b0120a";


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BG_COLOR UIColorFromRGB(0xefeff4)

#define YYScreenW [UIScreen mainScreen].bounds.size.width
#define YYScreenH [UIScreen mainScreen].bounds.size.height

#define ButtonColor [UIColor colorWithRed:156/255.0 green:197/255.0 blue:251/255.0 alpha:1.0]

@implementation MODropAlertView {
    
@private
    NSString *okButtonTitleStr;
    NSString *cancelButtonTitleString;
    NSString *titleStr;
    NSString *descrptionString;
    
    UIImageView *backgroundView;
    UIView *alertView;
    
    UILabel *titleLabel;
    UITextField *firstLineView;
    UITextField *secondLineView;
    UITextField *thridLineView;
    UILabel *tipsLabel;
    UIButton *okButton;
    UIButton *cancelButton;
    
    DropAlertViewType kType;
    UIColor *okButtonColor;
    UIColor *cancelButtonColor;
    blk successBlockCallback;
    blk failureBlockCallback;
}

#pragma mark - Initialized Drop Alert Methods

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                          successBlock:(blk)successBlock
                          failureBlock:(blk)failureBlock
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:cancelButtonTitle
                          okButtonColor:nil
                      cancelButtonColor:nil
                           successBlock:successBlock
                           failureBlock:failureBlock
                              alertType:DropAlertDefault];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                     cancelButtonColor:(UIColor *)cancelBtnColor
                          successBlock:(blk)successBlock
                          failureBlock:(blk)failureBlock
                             alertType:(DropAlertViewType)alertType
{
    self = [super init];
    if (self) {
        okButtonTitleStr = okButtonTitle;
        cancelButtonTitleString = cancelButtonTitle;
        descrptionString = description;
        titleStr = title;
        kType = alertType;
        okButtonColor = okBtnColor;
        cancelButtonColor = cancelBtnColor;
        successBlockCallback = successBlock;
        failureBlockCallback = failureBlock;
        [self initDropAlert];
        
        [firstLineView becomeFirstResponder];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [firstLineView resignFirstResponder];
    [secondLineView resignFirstResponder];
    [thridLineView resignFirstResponder];
}

- (void)thridLineViewDidChange:(UITextField *)textField {
    // 超过字符,不作输出
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
    
}

- (void)initDropAlert
{
    self.frame = [self mainScreenFrame];
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self makeBackgroundBlur];
    [self makeAlertPopupView];
    
    [self makeAlertButton:cancelButtonTitleString ? YES : NO];
    [self makeAlertTitleLabel];
    [self makeFirstAlertdescriptionView];
    [self makeSecondAlertdescriptionView];
    [self makeThridAlertdescriptionView];
    [self makeAlertTips];
    
    [self moveAlertPopupView];
}

#pragma mark - View Layout Methods
- (void)makeBackgroundBlur
{
    backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
    
    UIImage *image = [UIImage convertViewToImage];
    UIImage *blurSnapshotImage = nil;
    blurSnapshotImage = [image applyBlurWithRadius:5.0
                                         tintColor:[UIColor colorWithWhite:0.2
                                                                     alpha:0.7]
                             saturationDeltaFactor:1.8
                                         maskImage:nil];
    
    backgroundView.image = blurSnapshotImage;
    backgroundView.alpha = 0;
    
    [self addSubview:backgroundView];
}

- (void)makeAlertPopupView
{
//    CGRect frame = CGRectMake(0, 0, 200, 200);
    CGRect screen = [self mainScreenFrame];
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 40, 380)];
    
    alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
    
    alertView.layer.masksToBounds = YES;
    alertView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    [self addSubview:alertView];
}

- (void)makeAlertTitleLabel
{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin, kAlertTitleLabelHeight)];
    titleLabel.center = CGPointMake(CGRectGetWidth(alertView.frame)/2, kAlertTitleLabelTopMargin);
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor darkGrayColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [titleLabel.font fontWithSize:kAlertTitleLabelFontSize];
    
    [alertView addSubview:titleLabel];
}

- (void)makeFirstAlertdescriptionView
{
//    descriptionView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin, kAlertdescriptionViewHeight)];
    firstLineView = [[UITextField alloc] init];
    firstLineView.font = [UIFont systemFontOfSize:15];
    firstLineView.borderStyle = UITextBorderStyleNone;
    firstLineView.placeholder = @"第 一 行";
    [firstLineView setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [firstLineView setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
    firstLineView.textAlignment = NSTextAlignmentCenter;
    firstLineView.secureTextEntry =  NO;
    firstLineView.tintColor = ButtonColor;
    UIView *seperatorLine = [[UIView alloc] init];
    [firstLineView addSubview:seperatorLine];
    seperatorLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self->firstLineView);
        make.height.mas_equalTo(1.5);
    }];
    
    [alertView addSubview:firstLineView];
    firstLineView.frame = CGRectMake(kAlertButtonSideMargin, 60, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin * 2, kAlertdescriptionViewHeight);
    [firstLineView addTarget:self action:@selector(thridLineViewDidChange:) forControlEvents:UIControlEventEditingChanged];

}


- (void)makeSecondAlertdescriptionView
{
    secondLineView = [[UITextField alloc] init];
    secondLineView.font = [UIFont systemFontOfSize:15];
    secondLineView.borderStyle = UITextBorderStyleNone;
    secondLineView.placeholder = @"第 二 行";
    [secondLineView setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [secondLineView setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
    secondLineView.textAlignment = NSTextAlignmentCenter;
    secondLineView.secureTextEntry =  NO;
    secondLineView.tintColor = ButtonColor;
    UIView *seperatorLine = [[UIView alloc] init];
    [secondLineView addSubview:seperatorLine];
    seperatorLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self->secondLineView);
        make.height.mas_equalTo(1.5);
    }];
    
    [alertView addSubview:secondLineView];
    secondLineView.frame = CGRectMake(kAlertButtonSideMargin, 120, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin * 2, kAlertdescriptionViewHeight);
    [secondLineView addTarget:self action:@selector(thridLineViewDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)makeThridAlertdescriptionView
{
    thridLineView = [[UITextField alloc] init];
    thridLineView.font = [UIFont systemFontOfSize:15];
    thridLineView.borderStyle = UITextBorderStyleNone;
    thridLineView.placeholder = @"第 三 行";
    [thridLineView setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    [thridLineView setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
    thridLineView.textAlignment = NSTextAlignmentCenter;
    thridLineView.secureTextEntry =  NO;
    thridLineView.tintColor = ButtonColor;
    UIView *seperatorLine = [[UIView alloc] init];
    [thridLineView addSubview:seperatorLine];
    seperatorLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
    [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self->thridLineView);
        make.height.mas_equalTo(1.5);
    }];
    
    [alertView addSubview:thridLineView];
    thridLineView.frame = CGRectMake(kAlertButtonSideMargin, 180, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin * 2, kAlertdescriptionViewHeight);
    [thridLineView addTarget:self action:@selector(thridLineViewDidChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)makeAlertTips {
    tipsLabel = [[UILabel alloc]init];
    [tipsLabel setFrame:CGRectMake(10, alertView.height - 115, CGRectGetWidth(alertView.frame) - (kAlertButtonSideMargin * 2), 20)];
    tipsLabel.text = @"再爱不过三行 再恨不过两行 笔停处情止时";
    tipsLabel.textColor = [UIColor darkGrayColor];
    [tipsLabel setTextAlignment:NSTextAlignmentLeft];
    tipsLabel.font = [UIFont systemFontOfSize:15];
    
    [alertView addSubview:tipsLabel];
}

- (void)makeAlertButton:(BOOL)hasCancelButton
{
    okButton = [[UIButton alloc]init];
    if (hasCancelButton) {
        cancelButton = [[UIButton alloc]init];
        
        [okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        [cancelButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        
        [okButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)/4 + kAlertButtonsBetweenMargin,
                                        CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
        [cancelButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)*3/4 - kAlertButtonsBetweenMargin,
                                            CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
        
//        if (cancelButtonColor) {
//            [cancelButton setBackgroundImage:[UIImage imageWithColor:cancelButtonColor] forState:UIControlStateNormal];
//        } else {
//            [cancelButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertCancelButtonNormalColor]] forState:UIControlStateNormal];
//            [cancelButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertCancelButtonHighlightColor]] forState:UIControlStateHighlighted];
//        }
        [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];

//        [cancelButton setTitle:cancelButtonTitleString
//                      forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[cancelButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
        [cancelButton addTarget:self
                         action:@selector(pressAlertButton:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self setShadowLayer:cancelButton.layer];
        
        [alertView addSubview:cancelButton];
        
    } else {
        [okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) - (kAlertButtonSideMargin * 2), kAlertButtonHeight)];
        [okButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)/2, CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
    }
    [self setShadowLayer:okButton.layer];
    
//    if (okButtonColor) {
//        [okButton setBackgroundImage:[UIImage imageWithColor:okButtonColor] forState:UIControlStateNormal];
//    } else {
//        [okButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertOKButtonNormalColor]] forState:UIControlStateNormal];
//        [okButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertOKButtonHighlightColor]] forState:UIControlStateHighlighted];
//    }
    
    [okButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    
//    [okButton setTitle:okButtonTitleStr
//              forState:UIControlStateNormal];
    [okButton.titleLabel setFont:[okButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
    [okButton addTarget:self
                 action:@selector(pressAlertButton:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:okButton];
}

#pragma mark - View Animation Methods
- (void)moveAlertPopupView
{
    CGRect screen = [self mainScreenFrame];
    CATransform3D move = CATransform3DIdentity;
    CGFloat initAlertViewYPosition = (CGRectGetHeight(screen) + CGRectGetHeight(alertView.frame)) / 2;
    
    move = CATransform3DMakeTranslation(0, -initAlertViewYPosition, 0);
    move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    
    alertView.layer.transform = move;
}

- (void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    if( [self.delegate respondsToSelector:@selector(alertViewWillAppear:)] ) {
        [self.delegate alertViewWillAppear:self];
    }
    
    [self showAnimation];
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        self->backgroundView.alpha = 1.0f;
    }];
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         self->alertView.layer.transform = init;
                         
                     }
                     completion:^(BOOL finished) {
                         if( [self.delegate respondsToSelector:@selector(alertViewDidAppear:)] && finished) {
                             [self.delegate alertViewDidAppear:self];
                         }
                     }];
}

- (void)dismiss:(DropAlertButtonType)buttonType
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewWilldisappear:buttonType:)] ) {
        [self.delegate alertViewWilldisappear:self buttonType:buttonType];
    }
    [self dismissAnimation:buttonType];
}

- (void)dismissAnimation:(DropAlertButtonType)buttonType
{
    blk cb;
    switch (buttonType) {
        case DropAlertButtonOK:
            successBlockCallback ? cb = successBlockCallback: nil;
            break;
        case DropAlertButtonFail:
            failureBlockCallback ? cb = failureBlockCallback: nil;
        default:
            break;
    }
    
    NSString *content = @"";
    if (firstLineView.text.length) {
        content = firstLineView.text;
    }
    if (secondLineView.text.length) {
        content = [NSString stringWithFormat:@"%@\n\n%@", content, secondLineView.text];
    }
    if (thridLineView.text.length) {
        content = [NSString stringWithFormat:@"%@\n\n%@", content, thridLineView.text];
    }
    
    [UIView animateWithDuration:0.8f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect screen = [self mainScreenFrame];
                         CATransform3D move = CATransform3DIdentity;
                         CGFloat initAlertViewYPosition = CGRectGetHeight(screen);
                         
                         move = CATransform3DMakeTranslation(0, initAlertViewYPosition, 0);
                         move = CATransform3DRotate(move, -40 * M_PI/180, 0, 0, 1.0f);
                         self->alertView.layer.transform = move;
                         
                         self->backgroundView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (cb) {
                             cb(content);
                         }
                         else if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisappear:buttonType:)] && finished) {
                             [self.delegate alertViewDidDisappear:self buttonType:buttonType];
                         }
                     }];
    
}

#pragma mark - Button Methods
- (IBAction)pressAlertButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    DropAlertButtonType buttonType;
    BOOL blockFlag = false;
    
    if( [button isEqual:okButton] ) {
        NSLog(@"Pressed Button is OkButton");
        buttonType = DropAlertButtonOK;
        if (successBlockCallback) {
            blockFlag = true;
        }
    }
    else {
        NSLog(@"Pressed Button is CancelButton");
        buttonType = DropAlertButtonFail;
        if (failureBlockCallback) {
            blockFlag = true;
        }
    }
    
    if ( !blockFlag && [self.delegate respondsToSelector:@selector(alertViewPressButton:buttonType:)]) {
        [self.delegate alertViewPressButton:self buttonType:buttonType];
    }
    
    [self dismiss:buttonType];
    
}

#pragma mark - Util Methods
- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)setShadowLayer:(CALayer *)layer
{
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 0.6;
    layer.shadowOpacity = 0.3;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
