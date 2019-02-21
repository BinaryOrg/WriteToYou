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

- (instancetype)init {
    
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addIconNode];
        [self addNameNode];
        [self addContentNode];
        [self addLineNode];
        
        self.iconNode.URL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1550750864454&di=ee102b8cdeca92e1cd28a479105232e7&imgtype=0&src=http%3A%2F%2Fpic.feizl.com%2Fupload%2Fallimg%2F170614%2F2020204301-6.jpg"];
        
        self.nameNode.attributedText = [NSMutableAttributedString lh_makeAttributedString:@"Maker" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:15]);
        }];
        
        NSMutableAttributedString *contentAtt = [NSMutableAttributedString lh_makeAttributedString:@"我多想再见你\n哪怕匆匆一眼就别理\n路灯下昏黄的剪影\n越走越漫长的林径" attributes:^(NSMutableDictionary *make) {
            make.lh_font([UIFont systemFontOfSize:15]);
        }];
        
        NSMutableAttributedString *timeAtt = [NSMutableAttributedString lh_makeAttributedString:@" 5小时前" attributes:^(NSMutableDictionary *make) {
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
@end
