//
//  ZDDQR2TableViewCell.h
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDQR2TableViewCell : UITableViewCell
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@end

NS_ASSUME_NONNULL_END
