//
//  ZDDQRDetailViewController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDQRDetailViewController.h"
#import <YYWebImage/YYWebImage.h>
#import <MJRefresh/MJRefresh.h>
#import "TEMPMacro.h"
#import <MFNetworkManager/MFNetworkManager.h>

#import "ZDDDetailHeader1TableViewCell.h"
#import "ZDDDetailHeader2TableViewCell.h"
#import "ZDDCommentTableViewCell.h"
#import "UIView+ZDD.h"
#import "ZDDThemeConfiguration.h"
#import "ZDDLogController.h"
#import "UIColor+ZDDColor.h"

@interface ZDDQRDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ZDDQRDetailViewController

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT - STATUSBARHEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        __weak typeof(self) weakSelf = self;
        MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [weakSelf refreshPage];
        }];
        
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 19; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
            [idleImages addObject:image];
        }
        
        [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 4; i <= 19; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
            [refreshingImages addObject:image];
        }
        [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
        
        // 设置正在刷新状态的动画图片
        [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
        
        //隐藏时间
        gifHeader.lastUpdatedTimeLabel.hidden = YES;
        //隐藏状态
        gifHeader.stateLabel.hidden = YES;
        
        
        _tableView.mj_header = gifHeader;
        
        
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.title = @"详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(commentClick)];
    [self.view addSubview:self.tableView];
    [self sendRequest];
}

- (void)commentClick {
    if ([MFHUDManager isShowing]) {
        return;
    }
    if ([ZDDUserTool isLogin]) {
        //改名
        [self presentAlertController];
    }else {
        //login
        [self presentViewController:[ZDDLogController new] animated:YES completion:nil];
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

- (void)presentAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入要评论内容" preferredStyle:UIAlertControllerStyleAlert];
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tintColor = theme.selectTabColor;
    }];
    __weak typeof(alert) weakAlert = alert;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        [self startLoadingWithText:@"评论中..."];
        NSString *comments = strongAlert.textFields[0].text;
        [MFNETWROK post:@"Comment/Create"
                 params:@{
                          @"userId": [ZDDUserTool shared].user.user_id,
                          @"poemId": self.data.poem.poem_id,
                          @"content": comments
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    NSLog(@"%@", result);
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self stopLoading];
                            [self reloadNewData];
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self showErrorWithText:@"评论失败！"];
                        });
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self stopLoading];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorWithText:@"评论失败！"];
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

- (void)reloadNewData {
    [self sendRequest];
}

- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)sendRequest {
    [MFNETWROK post:@"Comment/ListCommentByPoemId"
             params:@{
                      @"poemId": self.data.poem.poem_id
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", result);
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    if (self.list.count) {
                        [self.list removeAllObjects];
                    }
                    for (NSDictionary *dic in result[@"data"]) {
                        ZDDDataModel *data = [ZDDDataModel yy_modelWithJSON:dic];
                        [self.list addObject:data];
                    }
                    
                    [self.tableView reloadData];
                }else {
                    
                }
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }
            } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                NSLog(@"%@", error.userInfo);
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }
            }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        if (self.data.poem.picture_path.count == 1) {
            ZDDDetailHeader1TableViewCell *cell = [[ZDDDetailHeader1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dqr1"];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.data.user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.nameLabel.text = self.data.user.user_name;
            [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.data.poem.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.summaryLabel.text = self.data.poem.content;
            cell.dateLabel.text = [self formatFromTS:self.data.poem.last_update_date];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(self.data.poem.star_num)];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(self.data.poem.comment_num)];
            if (self.data.poem.is_star) {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
            }else {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
            }
            [cell.summaryLabel setHeight:self.data.poem.content_height + 10];
            return cell;
        }else {
            ZDDDetailHeader2TableViewCell *cell = [[ZDDDetailHeader2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dqr2"];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.data.user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.nameLabel.text = self.data.user.user_name;
            [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.data.poem.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, self.data.poem.picture_path[1]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.summaryLabel.text = self.data.poem.content;
            cell.dateLabel.text = [self formatFromTS:self.data.poem.last_update_date];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(self.data.poem.star_num)];
            cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(self.data.poem.comment_num)];
            if (self.data.poem.is_star) {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
            }else {
                cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
            }
            [cell.summaryLabel setHeight:self.data.poem.content_height + 10];
            return cell;
        }
    } else {
        ZDDDataModel *data = self.list[indexPath.row];
        ZDDQRModel *qr = data.poem;
        ZDDUserModel *user = data.user;
        ZDDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
        if (!cell) {
            cell = [[ZDDCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
            cell.nameLabel.text = user.user_name;
            cell.summaryLabel.text = qr.content;
            [cell.summaryLabel setHeight:qr.content_height + 10];
            cell.dateLabel.text = [self formatFromTS:qr.last_update_date];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.row) {
        return ((SCREENWIDTH - 80)/2) + 80 + self.data.poem.content_height + 10 + 8;
    }
    else {
        ZDDDataModel *data = self.list[indexPath.row];
        ZDDQRModel *qr = data.poem;
        return 70 + qr.content_height + 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
