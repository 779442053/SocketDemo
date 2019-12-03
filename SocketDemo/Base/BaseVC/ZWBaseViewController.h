//
//  ZWBaseViewController.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWBsaeViewcontrollerProtocal.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWBaseViewController : UIViewController<ZWBsaeViewcontrollerProtocal>
/**
 是否隐藏Home条
 */
@property (nonatomic, assign) BOOL isHidenHomeLine;
@property (nonatomic, assign) BOOL statusBarHidden;

//===================////  自定义导航栏
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *navigationBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
- (void)setTitle:(NSString *)title;
- (void)showLeftBackButton;
/**
 *  VIEW是否渗透导航栏
 * (YES_VIEW渗透导航栏下／NO_VIEW不渗透导航栏下)
 */
@property (assign,nonatomic) BOOL isExtendLayout;
/**
 * 功能：设置修改StatusBar
 * 参数：（1）StatusBar样式：statusBarStyle
 *      （2）是否隐藏StatusBar：statusBarHidden
 *      （3）是否动画过渡：animated
 */

-(void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
            statusBarHidden:(BOOL)statusBarHidden
    changeStatusBarAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
