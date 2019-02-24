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

#import "ZDDQR1TableViewCell.h"
#import "ZDDQR2TableViewCell.h"

#import "ZDDFBViewController.h"
#import "ZDDNotificationName.h"

#import "ZDDQRDetailViewController.h"
#import "ZDDQRModel.h"
#import <YYWebImage/YYWebImage.h>
#import "ZDDLogController.h"
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
        
        
        //        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        ////            [weakSelf mf_loadMoreDataWithId:weakSelf.pagination.last_key];
        //        }];
        //        _tableView.mj_footer = footer;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage) name:FBSuccessNotification object:nil];
    self.navigationItem.title = @"写给前任";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_comment_reply_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(fbClick)];
    //    [self.view addSubview:self.tableView];
    [self sendRequest];
}

- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
}

- (void)sendRequest {
    [MFNETWROK get:@"" params:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDDQRModel *qr = self.list[indexPath.row];
    if (qr.pics.count == 1) {
        ZDDQR1TableViewCell *cell = [[ZDDQR1TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qr1"];
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:qr.pics[0]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = qr.summary;
        cell.dateLabel.text = qr.date;
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.like_count)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.comment_count)];
        if (qr.liked) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        return cell;
    }else {
        ZDDQR2TableViewCell *cell = [[ZDDQR2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qr2"];
        [cell.imageView1 yy_setImageWithURL:[NSURL URLWithString:qr.pics[0]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        [cell.imageView2 yy_setImageWithURL:[NSURL URLWithString:qr.pics[1]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        cell.summaryLabel.text = qr.summary;
        cell.dateLabel.text = qr.date;
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.like_count)];
        cell.commentCountLabel.text = [NSString stringWithFormat:@"%@", @(qr.comment_count)];
        if (qr.liked) {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_selected_20x20_"];
        }else {
            cell.likeImageView.image = [UIImage imageNamed:@"ic_messages_like_20x20_"];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((SCREENWIDTH - 80)/2) + 40 + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZDDQRDetailViewController *detail = [[ZDDQRDetailViewController alloc] init];
    
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

@end
