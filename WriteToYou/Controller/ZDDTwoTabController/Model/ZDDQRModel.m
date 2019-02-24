//
//  ZDDQRModel.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/22.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDQRModel.h"

@implementation ZDDQRModel
- (void)setContent:(NSString *)content {
    _content = content;
    self.content_height = [self heightWithString:content LabelFont:[UIFont systemFontOfSize:15] withLabelWidth:SCREENWIDTH - 60];
}
#pragma mark - 计算文本高度
- (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;
    
    if (string.length == 0) {
        height = 0;
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
        
        height = retSize.height;
    }
    
    return height;
}

@end
