//
//  AnnouncementsView.m
//  KuaiZhu
//
//  Created by Ghy on 2019/5/16.
//  Copyright © 2019年 su. All rights reserved.
//

#import "AnnouncementsView.h"
#import "AnnouncementsModel.h"
#import "BaseUIView.h"
@implementation AnnouncementsView
#define K_APP_BOX_WIDTH (KScreenWidth - 80)
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}


//MARK: - initView
-(void)initView{
    //标题
    [self addSubview:self.labTitle];
    
    //内容
    [self addSubview:self.labContent];
    
    //按钮
    [self addSubview:self.btnNext];
    
    //关闭
    [self addSubview:self.btnClose];
}

-(UILabel *)labTitle{
    if (!_labTitle) {
        CGRect rect = CGRectMake(0, 30, K_APP_BOX_WIDTH, 21);
        _labTitle = [[UILabel alloc]initWithFrame:rect];
        _labTitle.text = @"公告";
        _labTitle.textColor = [UIColor blackColor];
        _labTitle.font = [UIFont zwwBlodFont:16];
        _labTitle.textAlignment = NSTextAlignmentCenter;
    }
    
    return _labTitle;
}

-(UILabel *)labContent{
    if (!_labContent) {
        CGFloat x = 20;
        CGFloat w = K_APP_BOX_WIDTH - 2 * x;
        CGFloat y = self.labTitle.frame.size.height + self.labTitle.frame.origin.y + 15;
        CGRect rect = CGRectMake(x, y, w, 21);
        _labContent = [[UILabel alloc]initWithFrame:rect];
        _labContent.text = @"";
        _labContent.textColor = [UIColor blackColor];
        _labContent.font = [UIFont zwwNormalFont:14];
        _labContent.textAlignment = NSTextAlignmentLeft;
        
        _labContent.numberOfLines = 0;
        _labContent.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return _labContent;
}

-(UIButton *)btnNext{
    if (!_btnNext) {
        CGFloat y = self.labContent.frame.size.height + self.labContent.frame.origin.y + 30;
        CGFloat x = 45;
        CGFloat w = K_APP_BOX_WIDTH - 2 * x;
        CGFloat h = 40;
        _btnNext = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                AndTitle:@"关闭"
                           AndTitleColor:[UIColor whiteColor]
                              AndTxtFont:[UIFont systemFontOfSize:14]
                                AndImage:nil
                      AndbackgroundColor:[[UIColor alloc] colorFromHexInt:0xF75958 AndAlpha:1]
                          AndBorderColor:nil
                         AndCornerRadius:10
                            WithIsRadius:YES
                     WithBackgroundImage:nil
                         WithBorderWidth:0];
        
        [_btnNext addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnNext;
}

-(UIButton *)btnClose{
    if (!_btnClose) {
        CGFloat y = 5;
        CGFloat w = 30;
        CGFloat h = 30;
        CGFloat x = K_APP_BOX_WIDTH - w - 10;
        _btnClose = [BaseUIView createBtn:CGRectMake(x, y, w, h)
                                AndTitle:@""
                           AndTitleColor:nil
                              AndTxtFont:nil
                                AndImage:nil
                      AndbackgroundColor:nil
                          AndBorderColor:nil
                         AndCornerRadius:0
                            WithIsRadius:NO
                     WithBackgroundImage:[UIImage imageNamed:@"nav_right_close.png"]
                         WithBorderWidth:0];
        
        [_btnClose addTarget:self action:@selector(btnCloaseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnClose;
}


//MARK: - action
+(CGFloat)minViewHeight{
    return 175;
}

-(void)initUpdateView:(AnnouncementsModel *)model
        AndButtonInfo:(NSString *)strBtn
             AndIndex:(NSInteger)index WithOffsetH:(CGFloat)h{
    self.btnNext.tag = index;
    
    self.labContent.text = model.content;
    CGRect rect = self.labContent.frame;
    rect.size.height = h;
    self.labContent.frame = rect;
    
    rect = self.btnNext.frame;
    rect.origin.y = self.labContent.frame.size.height + self.labContent.frame.origin.y + 30;
    self.btnNext.frame = rect;
    [self.btnNext setTitle:strBtn forState:UIControlStateNormal];
}

-(IBAction)btnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(announcementsViewDelegateNextIndex:)]) {
        [self.delegate announcementsViewDelegateNextIndex:sender.tag];
    }
}

-(IBAction)btnCloaseAction:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        self.btnClose.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (finished) {
            
            self.btnClose.transform = CGAffineTransformMakeRotation(0);
            if (self.delegate && [self.delegate respondsToSelector:@selector(announcementsViewDelegateClose)]) {
                [self.delegate announcementsViewDelegateClose];
            }
        }
    }];
}
@end
