//
//  ZDDOneTabController.m
//  WriteToYou
//
//  Created by 张冬冬 on 2019/2/20.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDOneTabController.h"
#import "ZDDThreeLineCardView.h"
#import "ZDDSnowView.h"
#import "ZDDThreeLineCommentView.h"
#import "ZDDLogController.h"
#import "ZDDPostThreeLineController.h"
#import "MODropAlertView.h"

typedef void(^requestBlock)(NSInteger code, id result);


@interface ZDDOneTabController () <ZDDThreeLineCardViewDelegate, ZDDThreeLineCommentViewDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIButton *postBtn;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ZDDThreeLineCardView *cardView;
@property (nonatomic, strong) ZDDSnowView *snowView;
@property (nonatomic, strong) ZDDThreeLineCommentView *commentView;


@end

@implementation ZDDOneTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLb.text = @"愿你一别心宽，再生欢喜";

    [self setupUI];
    [self loadData];
    
}

- (void)setupUI {
    
    self.snowView = [[ZDDSnowView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBARHEIGHT, self.view.frame.size.width, 40)];
    [self.view addSubview:self.snowView];
    
    [self.view addSubview:self.cardView];
    
    [self.view addSubview:self.postBtn];
    [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(- 35);
        make.bottom.mas_equalTo(self.cardView.mas_top).mas_equalTo(-20);
    }];
    
    [self.view addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cardView.mas_top).mas_equalTo(-20);
        make.left.mas_equalTo(20);
    }];
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(- TABBARHEIGHT);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(51);
    }];
    
    
}

#pragma mark - 网络请求
- (void)loadData {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Poem/ListRecommendPoem" params:@{@"category" : @"shqs", @"userId" : [ZDDUserTool shared].user.user_id ? [ZDDUserTool shared].user.user_id : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (statusCode == 200) {
            NSArray *dataArr = [NSArray yy_modelArrayWithClass:ZDDThreeLineModel.class json:result[@"data"]];
            self.dataArray = dataArr;
            self.cardView.models = self.dataArray;
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        
    }];
    
}

//发布三行情书
- (void)postWithContent:(NSString *)content {
    
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Poem/Create" params:@{@"userId": [ZDDUserTool shared].user.user_id, @"title" : @"fffff", @"content" : content, @"category" : @"shqs", @"pictures" : @""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (statusCode == 200) {
            [MFHUDManager showSuccess:@"发表成功"];
            [self loadData];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager showError:@"发表失败"];
    }];
    
}

//发布评论
- (void)sendComment:(NSString *)comment WithModel:(ZDDThreeLineModel *)model {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Comment/Create" params:@{@"userId": [ZDDUserTool shared].user.user_id, @"poemId" : model.poem.poem_id, @"content" : comment} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (statusCode == 200) {
            [MFHUDManager showSuccess:@"评论成功"];
            ZDDDataModel *comment = [ZDDDataModel yy_modelWithJSON:result];
            if (comment.poem.poem_id.length) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:model.comments];
                [tempArr insertObject:comment atIndex:0];
                model.comments = tempArr.copy;
            }
            if (self.commentView.superview) {
                [self.commentView showWithModel:model];
            }
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager showError:@"发表失败"];
    }];
}

//获取评论列表
- (void)getCommentListWithId:(NSString *)poemId block:(requestBlock)block {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Comment/ListCommentByPoemId" params:@{@"poemId": poemId} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        block(statusCode, result);
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        block(statusCode, error);
    }];
}

//点击点赞
- (void)clickStar:(BOOL)isStar withModel:(ZDDThreeLineModel *)model {
    
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"Star/AddOrCancel" params:@{@"userId": [ZDDUserTool shared].user.user_id, @"poemId" : model.poem.poem_id, @"category" : @"poem"} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
    }];
    
    
}

#pragma mark - 点击事件
//点击发布
- (void)clickPostBtn {
    
    if ([ZDDUserTool isLogin]) {
        MODropAlertView *alert = [[MODropAlertView alloc]initDropAlertWithTitle:@"三行情书"
                                                                    description:@"aaa"
                                                                  okButtonTitle:@"OK"
                                                              cancelButtonTitle:@"Cancel"
                                                                   successBlock:^(NSString *content) {
                                                                       [self postWithContent:content];
                                                                   } failureBlock:^(NSString *content) {
                                                                       
                                                                   }];
        [alert show];
        
    }else {
        ZDDLogController *vc = [ZDDLogController new];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
    
    
}
//点击卡片
- (void)clickCardWithModel:(ZDDThreeLineModel *)model {
    __weak typeof(self)weakSelf = self;
    [self getCommentListWithId:model.poem.poem_id block:^(NSInteger code, id result) {
        if (code == 200) {
            model.comments = [NSArray yy_modelArrayWithClass:ZDDDataModel.class json:result[@"data"]];
            [weakSelf.commentView showWithModel:model];
        }else {
            [MFHUDManager showError:@"获取评论失败"];
        }
    }];
   
}


- (ZDDThreeLineCardView *)cardView {
    if (!_cardView) {
        _cardView = [[ZDDThreeLineCardView alloc] initWithFrame:CGRectMake(0, 150, SCREENWIDTH, SCREENHEIGHT - 150 - TABBARHEIGHT - 50)];
        _cardView.delegate = self;
    }
    return _cardView;
}

-(UIButton *)postBtn {
    if (!_postBtn) {
        _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_postBtn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
        [_postBtn setShowsTouchWhenHighlighted:NO];
        [_postBtn addTarget:self action:@selector(clickPostBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBtn;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = [UIColor grayColor];
    }
    return _titleLb;
}

- (ZDDThreeLineCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[ZDDThreeLineCommentView alloc] init];
        _commentView.delegate = self;
    }
    return _commentView;
}

@end
