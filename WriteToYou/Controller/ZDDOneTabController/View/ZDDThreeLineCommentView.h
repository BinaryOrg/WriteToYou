//
//  ZDDThreeLineCommentView.h
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDDThreeLineModel.h"


@protocol ZDDThreeLineCommentViewDelegate <NSObject>

@optional

- (void)sendComment:(NSString *)comment WithModel:(ZDDThreeLineModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThreeLineCommentView : UIView
-(void)showWithModel:(ZDDThreeLineModel *)model;
@property (nonatomic, weak) id <ZDDThreeLineCommentViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
