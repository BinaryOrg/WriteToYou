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

@interface ZDDFBViewController ()
<
CTAssetsPickerControllerDelegate
>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation ZDDFBViewController

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

-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
        _textView.textContainerInset = UIEdgeInsetsMake(15, 5, 5, 5);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeholder = @"想跟前女友说什么?";
        _textView.tintColor = [UIColor zdd_blueColor];
    }
    return _textView;
}

- (UIView *)rightButton {
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
    container.layer.masksToBounds = YES;
    container.layer.cornerRadius = 5;
    container.backgroundColor = [UIColor zdd_blueColor];
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
    
}

- (void)addButtonClick {
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
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];

}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.count = 0;
    if (self.assets.count) {
        [self.assets removeAllObjects];
    }
    self.assets = [NSMutableArray arrayWithArray:assets];
    if (self.assets.count == 1) {
        PHAsset *asset = self.assets[0];
        [self fetchImageWithAsset:asset imageBlock:^(NSData *data) {
            self.imageView1.image = [UIImage imageWithData:data];
        }];
    }else {
        PHAsset *asset1 = self.assets[0];
        [self fetchImageWithAsset:asset1 imageBlock:^(NSData *data) {
            self.imageView1.image = [UIImage imageWithData:data];
        }];
        PHAsset *asset2 = self.assets[1];
        [self fetchImageWithAsset:asset2 imageBlock:^(NSData *data) {
            self.imageView2.image = [UIImage imageWithData:data];
        }];
    }
}

- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSData*))imageBlock {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info)
    {
        NSLog(@"--%@", info);
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        // 直接得到最终的 NSData 数据
        NSLog(@"%@", info);
        if (imageBlock) {
            imageBlock(imageData);
        }
    }];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker {
    self.count = 0;
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
