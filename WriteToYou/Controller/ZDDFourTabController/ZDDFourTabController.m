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
@interface ZDDFourTabController ()
<
UITableViewDelegate,
UITableViewDataSource
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        ZDDPersonHeadTableViewCell *cell = [[ZDDPersonHeadTableViewCell alloc] init];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"sex_boy_110x110_"]];
        
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
            
        }else if (indexPath.row == 1) {
            [self presentViewController:[ZDDYZXSViewController new] animated:YES completion:nil];
        }
    }
    
}

@end
