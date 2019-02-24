//
//  ZDDFBViewController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDFBViewController.h"
#import "UIColor+ZDDColor.h"
#import "TEMPMacro.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import "ZDDNotificationName.h"
#import <QMUIKit.h>
#import "ZDDThemeConfiguration.h"
#import <MFNetworkManager/MFNetworkManager.h>

@interface ZDDFBViewController ()
<
CTAssetsPickerControllerDelegate
>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) BOOL fuck;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) QMUITips *tips;
@end

@implementation ZDDFBViewController

- (QMUITips *)tips {
    if (!_tips) {
        _tips = [QMUITips createTipsToView:self.view];
    }
    return _tips;
}


- (NSMutableArray *)images {
    if (!_images) {
        _images = @[].mutableCopy;
    }
    return _images;
}

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = @[].mutableCopy;
    }
    return _assets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
    self.navigationItem.title = @"发布新动态";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightButton]];
    [self.view addSubview:self.textView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 299, SCREENWIDTH - 40, 1)];
    line.backgroundColor = [UIColor zdd_colorWithRed:214 green:214 blue:214];
    [self.view addSubview:line];
    
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textView.frame) + 13, 20, 20)];
    addImageView.image = [UIImage imageNamed:@"ic_personal_tab_my_topic_20x20_"];
    [self.view addSubview:addImageView];
    addImageView.userInteractionEnabled = YES;
    
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.textView.frame), 100, 46)];
    addLabel.text = @"添加照片";
    addLabel.textColor = [UIColor zdd_grayColor];
    [self.view addSubview:addLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 30, 17 + CGRectGetMaxY(self.textView.frame), 7, 12)];
    rightImageView.image = [UIImage imageNamed:@"ic_common_arrow_right_7x12_"];
    [self.view addSubview:rightImageView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 300, SCREENWIDTH, 46);
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 346, SCREENWIDTH - 40, 1)];
    line1.backgroundColor = [UIColor zdd_colorWithRed:214 green:214 blue:214];
    [self.view addSubview:line1];
    
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(line1.frame) + 10, (SCREENWIDTH - 80)/2, ((SCREENWIDTH - 80)/2))];
    self.imageView1.layer.cornerRadius = 7;
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView1];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView1.frame) + 20, CGRectGetMaxY(line1.frame) + 10, (SCREENWIDTH - 80)/2, ((SCREENWIDTH - 80)/2))];
    self.imageView2.layer.cornerRadius = 7;
    self.imageView2.layer.masksToBounds = YES;
    self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView2];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.fuck) {
        [self.textView becomeFirstResponder];
    }
    self.fuck = YES;
    
}

-(UITextView *)textView {
    if (!_textView) {
        ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 20, 15, 20);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeholder = @"想跟前女友说什么?";
        _textView.tintColor = theme.selectTabColor;
    }
    return _textView;
}

- (UIView *)rightButton {
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
    container.layer.masksToBounds = YES;
    container.layer.cornerRadius = 5;
    container.backgroundColor = theme.selectTabColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.adjustsImageWhenHighlighted = NO;
    button.frame = container.bounds;
    [container addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(fbClick) forControlEvents:UIControlEventTouchUpInside];
    return container;
}

- (void)fbClick {
    if ([MFHUDManager isShowing]) {
        return;
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessNotification object:nil];
    self.imageView1.image ? [self.images addObject:self.imageView1.image] : nil;
    self.imageView2.image ? [self.images addObject:self.imageView2.image] : nil;
    [self startLoadingWithText:@"发布中..."];
    [MFNETWROK upload:@"Poem/Create"
               params:@{
                        @"userId": [ZDDUserTool shared].user.user_id,
                        @"content": self.textView.text,
                        @"category": @"xgqr"
                        }
                 name:@"pictures"
               images:self.images
           imageScale:1.f
            imageType:MFImageTypePNG
             progress:nil
              success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                  if ([result[@"resultCode"] isEqualToString:@"0"]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self stopLoading];
                          [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessNotification object:nil];
                      });
                      [self.navigationController popViewControllerAnimated:YES];
                  }else {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self showErrorWithText:@"发布失败！"];
                      });
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [self stopLoading];
                      });
                  }
              }
              failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self showErrorWithText:@"发布失败！"];
                  });
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self stopLoading];
                  });
              }];
    
}

- (void)addButtonClick {
    if ([MFHUDManager isShowing]) {
        return;
    }
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:^{
                self.imageView1.alpha = 0;
                self.imageView2.alpha = 0;
            }];
        });
    }];

}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.count = 0;
    if (self.assets.count) {
        [self.assets removeAllObjects];
    }
    self.assets = [NSMutableArray arrayWithArray:assets];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadingWithText:@"获取图片..."];
    });
    if (self.assets.count == 1) {
        PHAsset *asset = self.assets[0];
        [self fetchImageWithAsset:asset imageView:self.imageView1 imageBlock:^(NSData *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView1.image = [UIImage imageWithData:data];
                [self stopLoading];
            });
        }];
    }else {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHAsset *asset1 = self.assets[0];
            [self fetchImageWithAsset:asset1 imageView:self.imageView1 imageBlock:^(NSData *data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView1.image = [UIImage imageWithData:data];
                    dispatch_group_leave(group);
                });
            }];
        });
        
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHAsset *asset2 = self.assets[1];
            [self fetchImageWithAsset:asset2 imageView:self.imageView2 imageBlock:^(NSData *data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView2.image = [UIImage imageWithData:data];
                    dispatch_group_leave(group);
                });
            }];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
    }
}

- (void)startLoadingWithText:(NSString *)text {
    //    [QMUITips showLoading:text inView:self.view];
    //    [self.tips showLoading:text];
    [MFHUDManager showLoading:text];
}

- (void)showErrorWithText:(NSString *)text {
    //    [self.tips showError:text];
    [MFHUDManager showError:text];
}

- (void)showSuccessWithText:(NSString *)text {
    //    [self.tips showSucceed:text];
    [MFHUDManager showSuccess:text];
    
}

- (void)stopLoading {
    //    [QMUITips hideAllToastInView:self.view animated:YES];
    //    [self.tips hideAnimated:YES];
    [MFHUDManager dismiss];
}

- (void)fetchImageWithAsset:(PHAsset*)mAsset imageView:(UIImageView *)imageView imageBlock:(void(^)(NSData*))imageBlock {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info)
    {
        if (progress == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.alpha = 1;
                }];
            });
        }
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        // 直接得到最终的 NSData 数据
        
        {
            if (imageBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        imageView.alpha = 1;
                    }];
                });
                imageBlock(imageData);
            }
        }
    }];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    self.count = 0;
    self.imageView1.alpha = 1;
    self.imageView2.alpha = 1;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset {
    if (self.count >= 2) {
        return NO;
    }
    return YES;
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didSelectAsset:(PHAsset *)asset {
    self.count += 1;
}


- (void)assetsPickerController:(CTAssetsPickerController *)picker didDeselectAsset:(PHAsset *)asset {
    self.count -= 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

@end
