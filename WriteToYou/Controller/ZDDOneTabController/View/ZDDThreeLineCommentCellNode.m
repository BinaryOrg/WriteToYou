//
//  ZDDThreeLineCommentCellNode.m
//  WriteToYou
//
//  Created by Maker on 2019/2/21.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDThreeLineCommentCellNode.h"

@interface ZDDThreeLineCommentCellNode ()

@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASTextNode *contentNode;
@property (nonatomic, strong) ASDisplayNode *lineNode;

@end


@implementation ZDDThreeLineCommentCellNode

- (instancetype)initWithMode:(ZDDDataModel *)model {

    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addIconNode];
        [self addNameNode];
        [self addContentNode];
        [self addLineNode];
        
        self.iconNode.defaultImage = [UIImage imageNamed:@"sex_boy_110x110_"];
        self.iconNode.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", MFNETWROK.baseURL, model.user.avater]];;
        
        self.nameNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:model.user.user_name attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:15]);
        }];
        
        NSMutableAttributedString *contentAtt = [NSMutableAttributedString lh_makeAttributedString:model.poem.content attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:15]);
        }];
        
        NSString *time = [self formateDateWithTimestamp:model.poem.last_update_date];
        
        NSMutableAttributedString *timeAtt = [NSMutableAttributedString lh_makeAttributedString:time attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:13]).lh_color([UIColor grayColor]);
        }];
        
        NSMutableAttributedString *att = [NSMutableAttributedString new];
        [att appendAttributedString:contentAtt.copy];
        [att appendAttributedString:timeAtt.copy];
        
        self.contentNode.attributedText = att;
        
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASStackLayoutSpec *nameAndContent = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.nameNode, self.contentNode]];

    ASStackLayoutSpec *iconAndNamerLay = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:12 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[self.iconNode, nameAndContent]];
    
    ASInsetLayoutSpec *insertLay =[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(15, 20, 20, 20) child:iconAndNamerLay];
    
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:.0f justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[insertLay, self.lineNode]];
    
}

- (void)addIconNode {
    
    self.iconNode = [[ASNetworkImageNode alloc] init];
    self.iconNode.contentMode = UIViewContentModeScaleAspectFill;
    self.iconNode.style.preferredSize = CGSizeMake(30, 30);
    self.iconNode.cornerRadius = 15;
    [self addSubnode:self.iconNode];
    
}

- (void)addNameNode {
    
    self.nameNode = [[ASTextNode alloc] init];
    [self addSubnode:self.nameNode];
    
}

- (void)addContentNode {
    
    self.contentNode = [[ASTextNode alloc] init];
    [self addSubnode:self.contentNode];
    
}

- (void)addLineNode {
    _lineNode = [ASDisplayNode new];
    _lineNode.backgroundColor = color(237, 237, 237, 1);
    _lineNode.style.preferredSize = CGSizeMake(SCREENWIDTH, 0.5f);
    [_lineNode setLayerBacked:YES];
    [self addSubnode:_lineNode];
}


/**
 1分钟之内：显示 刚刚
 1~60分钟内：显示 XX分钟前
 1~24小时内-不跨天：显示 xx小时前
 1~24小时内-跨天：显示 昨天
 跨两天：显示 前天
 超过两天-没有跨年：显示 月日时分
 超过两天，且跨年：显示 年月日时分
 **/
- (NSString *)formateDateWithTimestamp:(NSInteger)ts {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"  %@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}
@end
