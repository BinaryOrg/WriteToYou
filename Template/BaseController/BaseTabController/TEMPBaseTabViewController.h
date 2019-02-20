//
//  TEMPBaseTabViewController.h
//  Template
//
//  Created by 张冬冬 on 2019/2/18.
//  Copyright © 2019 binary. All rights reserved.
//

#import "TEMPBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TEMPBaseTabViewController : TEMPBaseViewController
- (instancetype)initWithTabImageName:(nonnull NSString *)imageName
                   selectedImageName:(nonnull NSString *)selectedImageName
                               title:(nonnull NSString *)title;
@end

NS_ASSUME_NONNULL_END
