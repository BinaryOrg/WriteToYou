//
//  ZDDTwoTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDTwoTabController.h"
#import <MJRefresh/MJRefresh.h>
#import "TEMPMacro.h"
#import <MFNetworkManager/MFNetworkManager.h>

#import "ZDDQR0TableViewCell.h"
#import "ZDDQR1TableViewCell.h"
#import "ZDDQR2TableViewCell.h"

#import "ZDDFBViewController.h"
#import "ZDDNotificationName.h"

#import "ZDDQRDetailViewController.h"
#import "ZDDQRModel.h"
#import <YYWebImage/YYWebImage.h>
#import "ZDDLogController.h"
#import "ZDDDataModel.h"
@interface ZDDTwoTabController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ZDDTwoTabController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:QRFBSuccessNotification object:nil];
    self.navigationItem.title = @"写给前任";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_comment_reply_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(fbClick)];
    [self.view addSubview:self.tableView];
    [self sendRequest];
}

- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)loadNewData {
//    [self.tableView.mj_header beginRefreshing];
    [self sendRequest];
}

- (void)sendRequest {
    [MFNETWROK post:@"Poem/ListRecommendPoem"
             params:@{
                      @"orderBy": @"last_update_date",
                      @"category": @"xgqr",
                      @"userId": [ZDDUserTool shared].user.user_id,
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
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDDDataModel *data = self.list[indexPath.row];
    ZDDQRModel *qr = data.poem;
    ZDDUserModel *user = data.user;
    if (qr.picture_path.count == 1) {
        ZDDQR1TableViewCell *cell = [[ZDDQR1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qr1"];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.nameLabel.text = user.user_name;
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, qr.picture_path[0]]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = qr.content;
        cell.dateLabel.text = [self formatFromTS:qr.last_update_date];
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.star_num)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.comment_num)];
        if (qr.is_star) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        [cell.likeButton addTarget:self action:@selector(like1:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        ZDDQR2TableViewCell *cell = [[ZDDQR2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qr2"];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, user.avater]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.nameLabel.text = user.user_name;
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, qr.picture_path[0]]]  options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, qr.picture_path[1]]]  options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = qr.content;
        cell.dateLabel.text = [self formatFromTS:qr.last_update_date];
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.star_num)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.comment_num)];
        if (qr.is_star) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        [cell.likeButton addTarget:self action:@selector(like2:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

- (void)like1:(UIButton *)sender {
    ZDDQR1TableViewCell *cell = (ZDDQR1TableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZDDDataModel *data = self.list[indexPath.row];
    
    if (data.poem.is_star) {
        data.poem.star_num -= 1;
    }else {
        data.poem.star_num += 1;
        
    }
    [MFNETWROK post:@"Star/AddOrCancel" params:@{
                                                 @"userId": [ZDDUserTool shared].user.user_id,
                                                 @"poemId": data.poem.poem_id,
                                                 @"category": @"poem",
                                                 } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", result);
                                                 } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", error.userInfo);
                                                 }];
    data.poem.is_star = !data.poem.is_star;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)like2:(UIButton *)sender {
    ZDDQR2TableViewCell *cell = (ZDDQR2TableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZDDDataModel *data = self.list[indexPath.row];
    
    if (data.poem.is_star) {
        data.poem.star_num -= 1;
    }else {
        data.poem.star_num += 1;
        
    }
    [MFNETWROK post:@"Star/AddOrCancel" params:@{
                                                 @"userId": [ZDDUserTool shared].user.user_id,
                                                 @"poemId": data.poem.poem_id,
                                                 @"category": @"poem",
                                                 } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", result);
                                                 } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                                                     NSLog(@"%@", error.userInfo);
                                                 }];
    data.poem.is_star = !data.poem.is_star;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SCREENWIDTH - 80)/2) + 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZDDQRDetailViewController *detail = [[ZDDQRDetailViewController alloc] init];
    detail.data = self.list[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)fbClick {
    if ([ZDDUserTool isLogin]) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[ZDDFBViewController new] animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else {
        ZDDLogController *vc = [ZDDLogController new];

        [self presentViewController:vc animated:YES completion:nil];
    }
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
