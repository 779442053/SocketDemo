//
//  AppDelegate+ZWWAppDelegate.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//
#import "AppDelegate.h"
#import "Reachability.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (ZWWAppDelegate)
//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMengWithKey:(NSString *)key;
//初始化用户系统
-(void)initUserManager;
//键盘事件
- (void)zw_setKeyBord;
/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;
@end

NS_ASSUME_NONNULL_END
