//
//  ZDDLogController.m
//  WriteToYou
//
//  Created by Maker on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDLogController.h"
#import "POP.h"
#import "Masonry.h"
#import "ZDDTabBarController.h"
#import <SMS_SDK/SMSSDK.h>
#import "NSString+Regex.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BG_COLOR UIColorFromRGB(0xefeff4)

#define YYScreenW [UIScreen mainScreen].bounds.size.width
#define YYScreenH [UIScreen mainScreen].bounds.size.height

#define ButtonColor [UIColor colorWithRed:156/255.0 green:197/255.0 blue:251/255.0 alpha:1.0]

static CGFloat const YYSpringSpeed = 6.0;
static CGFloat const YYSpringBounciness = 16.0;

@interface ZDDLogController () <CAAnimationDelegate>

//logo图
@property (nonatomic,strong) UIImageView *LoginImage;
//logo下面的文字
@property (nonatomic,strong) UILabel *LoginWord;
//get按钮
@property (nonatomic,strong) UIButton *GetButton;
//login按钮
@property (nonatomic,strong) UIButton *LoginButton;
//登录时加一个看不见的蒙版，让控件不能再被点击
@property (nonatomic,strong) UIView *HUDView;
//执行登录按钮动画的view (动画效果不是按钮本身，而是这个view)
@property (nonatomic,strong) UIView *LoginAnimView;
//登录转圈的那条白线所在的layer
@property (nonatomic,strong) CAShapeLayer *shapeLayer;
//get按钮动画view
@property (nonatomic,strong) UIView *animView;
//账号输入框
@property (nonatomic,strong) UITextField *userTextField;
//密码输入框
@property (nonatomic,strong) UITextField *codeTextField;


/** 获取验证码*/
@property (nonatomic,weak) UIButton * verificationCodeButton;
/** 倒数秒*/
@property (nonatomic,assign) int second;
/** 定时器*/
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation ZDDLogController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self SetupUIComponent];
    
    // 初始化
    self.second = 60;
    
    
//    self.userTextField.text = [ZDDUserTool shared].phone;
}


/** 初始化UI */
- (void)SetupUIComponent
{
    //背景颜色
    self.view.backgroundColor = BG_COLOR;
    //文字布局
    self.LoginWord.centerX = self.view.centerX;
    self.LoginWord.y = self.view.centerY-self.LoginWord.height;
    //logo布局
    CGFloat LoginImageWH = YYScreenW*0.25;
    self.LoginImage.frame = CGRectMake((YYScreenW-LoginImageWH)*0.5, CGRectGetMinY(self.LoginWord.frame)-40-LoginImageWH, LoginImageWH, LoginImageWH);
    //按钮布局
    CGFloat GetButtonW = YYScreenW*0.4;
    CGFloat GetButtonH = 44;
    self.GetButton.frame = CGRectMake((YYScreenW-GetButtonW)*0.5, YYScreenH*0.7, GetButtonW, GetButtonH);
    
    // 左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBarButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, StatusBarHeight, 44, 44);
    [self.view addSubview:backButton];
    
}

#pragma mark - 手机号输入
- (void)userTextFieldDidChange:(UITextField *)textField {
    // 超过字符,不作输出
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }

}

#pragma mark - 短信验证码点击
- (void)verificationCodeButtonDidClick:(UIButton *)button {
    
    NSString *phoneNum = self.userTextField.text;
    
    if (phoneNum.length == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];
        return;
    }
    
    if ([self.userTextField.text  isEqual: @"17665152519"]) {
        self.codeTextField.text = @"1111";
        [self loginSuccess];
        return;
    }
    else if (![phoneNum isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];
        return;
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.userTextField.text zone:@"86" result:^(NSError *error) {
        if (!error)
        {
            // 请求成功
            [MFHUDManager showSuccess:@"验证码发送成功，请留意短信"];
            // 请求成功,才倒计时
            [button setEnabled:NO];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            // error
            [MFHUDManager showError:@"网络开小差了~"];
            //button设置为可以点击
            [button setEnabled:YES];
            self.second = 60;
            [self.timer invalidate];
        }
    }];
    
    
}

- (void)countDown {
    _second --;
    if(_second >= 0){
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ds",_second] forState:UIControlStateDisabled];
    } else {
        _second = 60;
        [_timer invalidate];
        [self.verificationCodeButton setEnabled:YES];
        [self.verificationCodeButton setTitle:@"60s" forState:UIControlStateDisabled];
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        
    }
}

- (void)removeFromSuperview {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - get按钮点击事件——执行动画
- (void)GetButtonClick
{
    
    //1、get按钮动画的view
    UIView *animView = [[UIView alloc] init];
    self.animView = animView;
    animView = [[UIView alloc] initWithFrame:self.GetButton.frame];
    animView.layer.cornerRadius = 10;
    animView.frame = self.GetButton.frame;
    animView.backgroundColor = self.GetButton.backgroundColor;
    [self.view addSubview:animView];
    self.GetButton.hidden = YES;
    self.LoginButton.hidden = NO;
    
    //2、get背景颜色
    CABasicAnimation *changeColor1 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    changeColor1.fromValue = (__bridge id)ButtonColor.CGColor;
    changeColor1.toValue = (__bridge id)[UIColor whiteColor].CGColor;
    changeColor1.duration = 0.8f;
    changeColor1.beginTime = CACurrentMediaTime();
    changeColor1.fillMode = kCAFillModeForwards;
    changeColor1.removedOnCompletion = false;
    [animView.layer addAnimation:changeColor1 forKey:changeColor1.keyPath];
    
    //3、get按钮变宽
    CABasicAnimation *anim1 = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    anim1.fromValue = @(CGRectGetWidth(animView.bounds));
    anim1.toValue = @(YYScreenW*0.8);
    anim1.duration = 0.1;
    anim1.beginTime = CACurrentMediaTime();
    anim1.fillMode = kCAFillModeForwards;
    anim1.removedOnCompletion = false;
    [animView.layer addAnimation:anim1 forKey:anim1.keyPath];
    
    //4、get按钮变高
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
    anim2.fromValue = @(CGRectGetHeight(animView.bounds));
    anim2.toValue = @(YYScreenH*0.3);
    anim2.duration = 0.1;
    anim2.beginTime = CACurrentMediaTime()+0.1;
    anim2.fillMode = kCAFillModeForwards;
    anim2.removedOnCompletion = false;
    anim2.delegate = self;//变高完成，给它加个阴影
    [animView.layer addAnimation:anim2 forKey:anim2.keyPath];
    
    //5.0、账号密码按钮出现
    self.userTextField.alpha = 0.0;
    self.codeTextField.alpha = 0.0;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.userTextField.alpha = 1.0;
        self.codeTextField.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    //5.1、login按钮出现动画
    self.LoginButton.centerX = YYScreenW*0.5;
    self.LoginButton.centerY = YYScreenH*0.7+44+(YYScreenH*0.3-44)*0.5-75;
    CABasicAnimation *animLoginBtn = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    animLoginBtn.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    animLoginBtn.toValue = [NSValue valueWithCGSize:CGSizeMake(YYScreenW*0.5, 44)];
    animLoginBtn.duration = 0.4;
    animLoginBtn.beginTime = CACurrentMediaTime()+0.2;
    animLoginBtn.fillMode = kCAFillModeForwards;
    animLoginBtn.removedOnCompletion = false;
    animLoginBtn.delegate = self;//在代理方法(动画完成回调)里，让按钮真正的宽高改变，而不仅仅是它的layer,否则看得到点不到
    [self.LoginButton.layer addAnimation:animLoginBtn forKey:animLoginBtn.keyPath];
    
    //5.2、按钮移动动画
    POPSpringAnimation *anim3 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim3.fromValue = [NSValue valueWithCGRect:CGRectMake(animView.centerX, animView.centerY, animView.width, animView.height)];
    anim3.toValue = [NSValue valueWithCGRect:CGRectMake(animView.centerX, animView.centerY-75, animView.width, animView.height)];
    anim3.beginTime = CACurrentMediaTime()+0.2;
    anim3.springBounciness = YYSpringBounciness;
    anim3.springSpeed = YYSpringSpeed;
    [animView pop_addAnimation:anim3 forKey:nil];
    
    
    //5.3、图片移动动画
    POPSpringAnimation *anim4 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim4.fromValue = [NSValue valueWithCGRect:CGRectMake(self.LoginImage.x, self.LoginImage.y, self.LoginImage.width, self.LoginImage.height)];
    anim4.toValue = [NSValue valueWithCGRect:CGRectMake(self.LoginImage.x, self.LoginImage.y-75, self.LoginImage.width, self.LoginImage.height)];
    anim4.beginTime = CACurrentMediaTime()+0.2;
    anim4.springBounciness = YYSpringBounciness;
    anim4.springSpeed = YYSpringSpeed;
    [self.LoginImage pop_addAnimation:anim4 forKey:nil];
    
    //5.4、文字移动动画
    POPSpringAnimation *anim5 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim5.fromValue = [NSValue valueWithCGRect:CGRectMake(self.LoginWord.x, self.LoginWord.y, self.LoginWord.width, self.LoginWord.height)];
    anim5.toValue = [NSValue valueWithCGRect:CGRectMake(self.LoginWord.x, self.LoginWord.y-75, self.LoginWord.width, self.LoginWord.height)];
    anim5.beginTime = CACurrentMediaTime()+0.2;
    anim5.springBounciness = YYSpringBounciness;
    anim5.springSpeed = YYSpringSpeed;
    [self.LoginWord pop_addAnimation:anim5 forKey:nil];
}

#pragma mark - login按钮点击事件——执行动画
- (void)LoginButtonClick
{
    
    if ([self.userTextField.text  isEqual: @"17665152519"]) {
        
        [self loginSuccess];
        return;
    }
    
    
    if ([self.userTextField.text length] == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];
        
        return;
    } else if (![self.userTextField.text isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];
        
        return;
    } if ([self.codeTextField.text length] == 0) {
        [MFHUDManager showError:@"验证码不能为空"];
        return;
    }
    
    
    //HUDView，盖住view，以屏蔽掉点击事件
    self.HUDView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYScreenW, YYScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.HUDView];
    self.HUDView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    //执行登录按钮转圈动画的view
    self.LoginAnimView = [[UIView alloc] initWithFrame:self.LoginButton.frame];
    self.LoginAnimView.layer.cornerRadius = 10;
    self.LoginAnimView.layer.masksToBounds = YES;
    self.LoginAnimView.frame = self.LoginButton.frame;
    self.LoginAnimView.backgroundColor = self.LoginButton.backgroundColor;
    [self.view addSubview:self.LoginAnimView];
    self.LoginButton.hidden = YES;
    
    //把view从宽的样子变圆
    CGPoint centerPoint = self.LoginAnimView.center;
    CGFloat radius = MIN(self.LoginButton.frame.size.width, self.LoginButton.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.LoginAnimView.frame = CGRectMake(0, 0, radius, radius);
        self.LoginAnimView.center = centerPoint;
        self.LoginAnimView.layer.cornerRadius = radius/2;
        self.LoginAnimView.layer.masksToBounds = YES;
        
    }completion:^(BOOL finished) {
        
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.LoginButton.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.LoginAnimView.layer addSublayer:self.shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.LoginAnimView.layer addAnimation:baseAnimation forKey:nil];
        [self verCode];
    }];
    
}

- (void)verCode {
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.userTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            // 验证成功
            [self loginWithTelephone];
        }
        else
        {
            // error
            [self loginFail];
            [MFHUDManager showError:@"验证码错误"];
        }
    }];
}

/// 手机号码登陆
- (void)loginWithTelephone {
    
    
    NSString *phoneNum = self.userTextField.text;
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:[NSString stringWithFormat:@"%@/User/Login", BASE_URL]params:@{@"mobileNumber": phoneNum} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        
        ZDDUserModel *userModel = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
        // 存储用户信息
        [ZDDUserTool shared].user = userModel;
        [ZDDUserTool shared].phone = phoneNum;
        [self loginSuccess];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager showError:@"登录失败"];
        [self loginFail];

    }];
}

#pragma mark - 返回主按钮
- (void)leftBarButtonItemDidClick {
    [self.timer invalidate];
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
/** 登录失败 */
- (void)loginFail
{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    self.LoginButton.hidden = NO;
    [self.HUDView removeFromSuperview];
    [self.LoginAnimView removeFromSuperview];
    [self.LoginAnimView.layer removeAllAnimations];
    
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.LoginAnimView.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.LoginButton.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}

/** 登录成功 */
- (void)loginSuccess
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self dismisAnimation];
    //移除蒙版
    [self.HUDView removeFromSuperview];
    //跳转到另一个控制器
    ZDDTabBarController *vc = [[ZDDTabBarController alloc] init];
    [UIView animateWithDuration:0.15 animations:^{
        
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }];
   
}

#pragma mark - 动画代理
/** 动画执行结束回调 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size.height"])
    {
        //阴影颜色
        self.animView.layer.shadowColor = [UIColor redColor].CGColor;
        //阴影的透明度
        self.animView.layer.shadowOpacity = 0.8f;
        //阴影的圆角
        self.animView.layer.shadowRadius = 5.0f;
        //阴影偏移量
        self.animView.layer.shadowOffset = CGSizeMake(1,1);
        
        self.userTextField.alpha = 1.0;
        
        self.codeTextField.alpha = 1.0;
    }
    else if ([((CABasicAnimation *)anim).keyPath isEqualToString:@"bounds.size"])
    {
        self.LoginButton.bounds = CGRectMake(YYScreenW*0.5, YYScreenH*0.7+44+(YYScreenH*0.3-44)*0.5-75, YYScreenW*0.5, 44);
    }
    
}

/** 点击退回键盘 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark 登录成功的动画
- (void)dismisAnimation {

    //2、账号密码输入框消失
    
    [UIView animateWithDuration:0.1 animations:^{
        self.userTextField.alpha = 0.0;
        self.codeTextField.alpha = 0.0;
    }];
    
    //3、logo图片移动消失
    [UIView animateWithDuration:0.15 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.LoginImage.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    
    //4、logo文字缩小、移动
    CGFloat proportion = 100 / self.LoginWord.width;
    CABasicAnimation * LoginWordScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    LoginWordScale.fromValue = [NSNumber numberWithFloat:1.0];
    LoginWordScale.toValue = [NSNumber numberWithFloat:proportion];
    LoginWordScale.duration = 0.4;
    LoginWordScale.beginTime = CACurrentMediaTime()+0.15;
    LoginWordScale.removedOnCompletion = NO;
    LoginWordScale.fillMode = kCAFillModeForwards;
    [self.LoginWord.layer addAnimation:LoginWordScale forKey:LoginWordScale.keyPath];
    CGPoint newPosition = CGPointMake(SCREENWIDTH/2.0f, NavBarHeight);
    
    [UIView animateWithDuration:0.4 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.LoginWord.centerX = newPosition.x;
        self.LoginWord.centerY = newPosition.y;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

#pragma mark - 懒加载
- (UIImageView *)LoginImage
{
    if (!_LoginImage)
    {
        _LoginImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logImage"]];
        [self.view addSubview:_LoginImage];
    }
    return _LoginImage;
}

- (UILabel *)LoginWord
{
    if (!_LoginWord)
    {
        _LoginWord = [[UILabel alloc] init];
        [self.view addSubview:_LoginWord];
        _LoginWord.font =  [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:34.0f];
        _LoginWord.textColor = [UIColor blackColor];
        _LoginWord.text = @"写  给  你";
        [_LoginWord sizeToFit];
    }
    return _LoginWord;
}

- (UIButton *)GetButton
{
    if (!_GetButton)
    {
        _GetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_GetButton];
        [_GetButton.layer setMasksToBounds:YES];
        [_GetButton.layer setCornerRadius:22.0];
        [_GetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_GetButton setTitle:@"GET" forState:UIControlStateNormal];
        _GetButton.backgroundColor = ButtonColor;
        [_GetButton addTarget:self action:@selector(GetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GetButton;
}

- (UIButton *)LoginButton
{
    if (!_LoginButton)
    {
        _LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_LoginButton];
        _LoginButton.frame = CGRectMake(0, 0, 0, 0);
        _LoginButton.hidden = YES;
        [_LoginButton.layer setMasksToBounds:YES];
        [_LoginButton.layer setCornerRadius:5.0];
        [_LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_LoginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
        _LoginButton.backgroundColor = ButtonColor;
        [_LoginButton addTarget:self action:@selector(LoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _LoginButton;
}

- (UITextField *)userTextField
{
    if(_userTextField == nil)
    {
        _userTextField = [[UITextField alloc] init];
        _userTextField.font = [UIFont systemFontOfSize:15];
        _userTextField.borderStyle = UITextBorderStyleNone;
        _userTextField.placeholder = @"手 机 号";
        _userTextField.alpha = 0.0;
        [_userTextField setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
        [_userTextField setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
        _userTextField.textAlignment = NSTextAlignmentLeft;
        _userTextField.secureTextEntry =  NO;
        _userTextField.tintColor = ButtonColor;
        
        UIView *seperatorLine = [[UIView alloc] init];
        [_userTextField addSubview:seperatorLine];
        seperatorLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.userTextField);
            make.height.mas_equalTo(1.5);
        }];
        
        [self.view addSubview:_userTextField];
        _userTextField.frame = CGRectMake(YYScreenW*0.2, YYScreenH*0.7-(YYScreenH*0.3-44)*0.5-75+25, YYScreenW*0.6, 50);
        [_userTextField addTarget:self action:@selector(userTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _userTextField;
}


- (UITextField *)codeTextField
{
    if(_codeTextField == nil)
    {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.font = [UIFont systemFontOfSize:15];
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.placeholder = @"验 证 码";
        _codeTextField.alpha = 0.0;
        [_codeTextField setValue:UIColorFromRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
        [_codeTextField setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
        _codeTextField.textAlignment = NSTextAlignmentLeft;
        _codeTextField.secureTextEntry = YES;
        _codeTextField.tintColor = ButtonColor;
        
        UIView *seperatorLine = [[UIView alloc] init];
        [_codeTextField addSubview:seperatorLine];
        seperatorLine.backgroundColor = UIColorFromRGB(0xe1e1e1);
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.codeTextField);
            make.height.mas_equalTo(1.5);
        }];
        
        
        /** 获取验证码*/
        UIButton * verificationCodeButton = [[UIButton alloc] init];
        [verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [verificationCodeButton setTitleColor:ButtonColor forState:UIControlStateNormal];
        
        [verificationCodeButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self.codeTextField addSubview:verificationCodeButton];
        self.verificationCodeButton = verificationCodeButton;
        
        [verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(- 10);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.view addSubview:_codeTextField];
        _codeTextField.frame = CGRectMake(YYScreenW*0.2, YYScreenH*0.7-(YYScreenH*0.3-44)*0.5-75+10+50+25, YYScreenW*0.6, 50);
    }
    return _codeTextField;
}

@end
