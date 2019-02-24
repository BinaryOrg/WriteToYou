//
//  ZDDFourTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDFourTabController.h"
#import "ZDDYZXSViewController.h"
#import "ZDDWDFBViewController.h"
#import "TEMPMacro.h"
#import "ZDDPersonHeadTableViewCell.h"
#import "ZDDPersonSettingTableViewCell.h"
#import "ZDDPersonLogoutTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import "ZDDNotificationName.h"
#import "ZDDUserModel.h"

#import "ZDDLogController.h"
#import <QMUIKit/QMUIKit.h>
#import "ZDDThemeConfiguration.h"
#import "UIColor+ZDDColor.h"
#import <MFHUDManager/MFHUDManager.h>
@interface ZDDFourTabController ()
<
UITableViewDelegate,
UITableViewDataSource,
QMUIAlbumViewControllerDelegate,
QMUIImagePickerViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *funcList;
@property (nonatomic, strong) QMUITips *tips;
@end

@implementation ZDDFourTabController

- (QMUITips *)tips {
    if (!_tips) {
        _tips = [QMUITips createTipsToView:self.view];
    }
    return _tips;
}

- (NSArray *)funcList {
    if (!_funcList) {
        _funcList = @[
                      @"我的发布",
                      @"一纸相思"
                      ];
    }
    return _funcList;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - STATUSBARHEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCustomInfo) name:LoginSuccessNotification object:nil];
}

- (void)reloadCustomInfo {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([ZDDUserTool isLogin]) {
        return 3;
//    }
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) {
        return 1;
    }
    else if (section == 1) {
        return self.funcList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        ZDDUserModel *user = [ZDDUserTool shared].user;
        ZDDPersonHeadTableViewCell *cell = [[ZDDPersonHeadTableViewCell alloc] init];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MFNETWROK.baseURL, user.avater]] placeholder:[UIImage imageNamed:@"sex_boy_110x110_"]];
        cell.nameLabel.text = [ZDDUserTool isLogin] ? user.user_name : @"登录";
        [cell.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [cell.avatarButton addTarget:self action:@selector(avatar) forControlEvents:UIControlEventTouchUpInside];
        cell.joinLabel.text = [ZDDUserTool isLogin] ? [NSString stringWithFormat:@"join in %@", [self formatFromTS:user.create_date]] : @"";
        return cell;
    }
    else if (indexPath.section == 1) {
        ZDDPersonSettingTableViewCell *cell = [[ZDDPersonSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
        cell.textLabel.text = self.funcList[indexPath.row];
        return cell;
    }
    
    return [[ZDDPersonLogoutTableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 80;
    }
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return CGFLOAT_MIN;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (!indexPath.row) {
            if ([ZDDUserTool isLogin]) {
                self.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:[ZDDWDFBViewController new] animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }
            else {
                [self presentViewController:[ZDDLogController new] animated:YES completion:nil];
            }
        }else if (indexPath.row == 1) {
            [self presentViewController:[ZDDYZXSViewController new] animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 2) {
        [[ZDDUserTool shared] clearUserInfo];
        [self reloadCustomInfo];
    }
    
}

- (void)login {
    if ([ZDDUserTool isLogin]) {
        //改名
        [self presentAlertController];
    }else {
        //login
        [self presentViewController:[ZDDLogController new] animated:YES completion:nil];
    }
}

- (void)avatar {
    if ([ZDDUserTool isLogin]) {
        //改avatar
        [self presentAlbumViewControllerWithTitle:@"请选择头像"];
    }else {
        //login
        [self presentViewController:[ZDDLogController new] animated:YES completion:nil];
    }
}

- (void)presentAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入要修改的用户名" preferredStyle:UIAlertControllerStyleAlert];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tintColor = theme.selectTabColor;
    }];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        [self startLoadingWithText:@"修改中..."];
        NSString *user_name = strongAlert.textFields[0].text;
        [MFNETWROK post:@"User/ChangeUserInfo"
                 params:@{
                          @"userId": [ZDDUserTool shared].user.user_id,
                          @"userName": user_name,
                          @"sex": @"m"
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    NSLog(@"%@", result);
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        ZDDUserModel *user = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
                        [ZDDUserTool shared].user = user;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoading];
                            [self reloadCustomInfo];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showErrorWithText:@"修改失败！"];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self stopLoading];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorWithText:@"修改失败！"];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self stopLoading];
                    });
                }];
    }];
    [cancel setValue:[UIColor zdd_skyBlueColor] forKey:@"_titleTextColor"];
    [ensure setValue:[UIColor zdd_skyBlueColor] forKey:@"_titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:ensure];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = title;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    [albumViewController pickLastAlbumGroupDirectlyIfCan];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.allowsMultipleSelection = NO;
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset afterImagePickerPreviewViewControllerUpdate:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startLoadingWithText:@"上传图片..."];
        });
    }];
    
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        NSLog(@"%@", info);
        [MFNETWROK upload:@"User/ChangeUserAvater"
                   params:@{
                            @"userId": [ZDDUserTool shared].user.user_id
                            }
                     name:@"pictures"
               imageDatas:@[imageData]
                 progress:nil
                  success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                      NSLog(@"%@", result);
                      if ([result[@"resultCode"] isEqualToString:@"0"]) {
                          ZDDUserModel *user = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
                          [ZDDUserTool shared].user = user;
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self stopLoading];
                              [self reloadCustomInfo];
                          });
                      }else {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [self showErrorWithText:@"上传失败！"];
                          });
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              [self stopLoading];
                          });
                      }
                  }
                  failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorWithText:@"上传失败！"];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self stopLoading];
                    });
                  }];
    }];
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

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}

@end
