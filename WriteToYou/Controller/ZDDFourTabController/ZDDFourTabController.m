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

@interface ZDDFourTabController ()
<
UITableViewDelegate,
UITableViewDataSource,
QMUIAlbumViewControllerDelegate,
QMUIImagePickerViewControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *funcList;
@end

@implementation ZDDFourTabController

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
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:user.avatar] placeholder:[UIImage imageNamed:@"sex_boy_110x110_"]];
        cell.nameLabel.text = [ZDDUserTool isLogin] ? user.user_name : @"登录";
        [cell.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [cell.avatarButton addTarget:self action:@selector(avatar) forControlEvents:UIControlEventTouchUpInside];
        cell.joinLabel.text = [ZDDUserTool isLogin] ? [NSString stringWithFormat:@"join in %@", @(user.create_date)] : @"";
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
    QMUIAlertController *alert = [QMUIAlertController alertControllerWithTitle:nil message:@"请输入要修改的用户名" preferredStyle:QMUIAlertControllerStyleAlert];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [alert addTextFieldWithConfigurationHandler:^(QMUITextField *textField) {
        textField.tintColor = theme.selectTabColor;
    }];
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil];
    QMUIAlertAction *ensure = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        NSString *user_name = aAlertController.textFields[0].text;
        [MFNETWROK post:@""
                 params:@{
                          
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                
                }];
    }];
    
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
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadingWithText:@"获取图片..."];
    });
    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
        NSLog(@"%@", info);
        [MFNETWROK upload:@"" params:nil name:@"" imageDatas:@[imageData] progress:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZDDUserTool shared].user = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
                [self reloadCustomInfo];
                [self stopLoading];
            });
        } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopLoading];
            });
        }];
    }];
}

- (void)startLoadingWithText:(NSString *)text {
    [QMUITips showLoading:text inView:self.view];
}

- (void)stopLoading {
    [QMUITips hideAllToastInView:self.view animated:YES];
}

@end
