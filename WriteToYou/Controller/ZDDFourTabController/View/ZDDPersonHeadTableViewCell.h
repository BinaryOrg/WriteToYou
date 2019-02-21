//
//  ZDDPersonHeadTableViewCell.h
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDPersonHeadTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIImageView *avatarImageView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *joinLabel;
@property (nonatomic ,strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *loginButton;
@end

NS_ASSUME_NONNULL_END
