//
//  ZDDThreeLinesCell.h
//  WriteToYou
//
//  Created by Maker on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDDThreeLineModel.h"

@protocol ZDDThreeLinesCellDelegate <NSObject>

- (void)clickStar:(BOOL)isStar withModel:(ZDDThreeLineModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThreeLinesCell : UICollectionViewCell

@property (nonatomic, weak) id <ZDDThreeLinesCellDelegate> delegate;
@property (nonatomic, strong) ZDDThreeLineModel *model;


@end

NS_ASSUME_NONNULL_END
