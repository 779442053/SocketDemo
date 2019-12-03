//
//  AnnouncementsView.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/16.
//  Copyright © 2019年 su. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnnouncementsModel;

NS_ASSUME_NONNULL_BEGIN

@protocol AnnouncementsViewDelegate <NSObject>

@optional
/** 下一条 */
-(void)announcementsViewDelegateNextIndex:(NSInteger)index;

@optional
/** 关闭 */
-(void)announcementsViewDelegateClose;

@end

/**
 * 公告视图
 */
@interface AnnouncementsView : UIView

@property(nonatomic,weak) id<AnnouncementsViewDelegate>delegate;

//公告标题
@property(nonatomic,strong) UILabel *labTitle;

//公告内容
@property(nonatomic,strong) UILabel *labContent;

//下一步按钮
@property(nonatomic,strong) UIButton *btnNext;

//关闭按钮
@property(nonatomic,strong) UIButton *btnClose;

+(CGFloat)minViewHeight;

-(void)initUpdateView:(AnnouncementsModel *)model
        AndButtonInfo:(NSString *)strBtn
             AndIndex:(NSInteger)index WithOffsetH:(CGFloat)h;

@end

NS_ASSUME_NONNULL_END
