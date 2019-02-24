//
//  ZDDThreeLineCardView.h
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDDThreeLineModel.h"

@protocol ZDDThreeLineCardViewDelegate <NSObject>

@optional

- (void)refreshData;
- (void)clickCardWithModel:(ZDDThreeLineModel *)model;
- (void)clickStar:(BOOL)isStar withModel:(ZDDThreeLineModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThreeLineCardView : UIView

@property(nonatomic, copy) NSArray <ZDDThreeLineModel *>*models;
@property (nonatomic, weak) id <ZDDThreeLineCardViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
