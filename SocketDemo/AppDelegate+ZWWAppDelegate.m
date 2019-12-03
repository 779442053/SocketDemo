//
//  AppDelegate+ZWWAppDelegate.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "AppDelegate+ZWWAppDelegate.h"
#import "ZWDataManager.h"
#import "ZWUserModel.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import "JSGetServerViewController.h"
@implementation AppDelegate (ZWWAppDelegate)
#pragma ===========键盘的回收事件 =============
-(void)zw_setKeyBord{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//点击背景,收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES;//控制键盘上的工具条文字颜色是否用户自定义
    manager.toolbarDoneBarButtonItemText =@"完成";//将右边Done改成完成
    manager.enableAutoToolbar = YES;//显示输入框提示栏
    manager.toolbarManageBehaviour =IQAutoToolbarByTag;
}
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (@available(iOS 7.0, *)) {
        self.window.tintColor = [UIColor colorWithHexString:@"#F7F8F7"];
    }
    [[UIButton appearance] setExclusiveTouch:YES];
}
#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    [ZWDataManager readUserData];
    //初始化数据库表
}
#pragma mark ————— 友盟 初始化 —————
-(void)initUMengWithKey:(NSString *)key{
    [UMConfigure initWithAppkey:key channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    [self initBugly];
}
-(UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
/** Bugly */
-(void)initBugly{
    @autoreleasepool {
        //开启Bugly配置
        BuglyConfig *config = [[BuglyConfig alloc] init];
        config.delegate = self;
        //SDK Debug信息
#if DEBUG
        config.debugMode = YES;
        config.consolelogEnable = YES;
#else
        config.debugMode = NO;
        config.consolelogEnable = NO;
#endif
        //卡顿监控开关，默认关闭
        config.blockMonitorEnable = YES;
        //卡顿监控判断间隔，单位为秒
        config.blockMonitorTimeout = 1.0;
        //非正常退出事件记录开关，默认关闭
        config.unexpectedTerminatingDetectionEnable = YES;
        //设置自定义日志上报的级别，默认不上报自定义日志
        config.reportLogLevel = BuglyLogLevelDebug;
        [Bugly startWithAppId:K_APP_BUGLY_APP_ID config:config];
    }
}
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception{
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    ZWWLog(@"++++++ callStackSymbols ++++++\n%@\n++++++ reason ++++++\n%@\n++++++ name ++++++\n%@",arr, reason, name);
    
    NSString *strLog = [NSString stringWithFormat:@"callStackSymbols：%@\n reason：%@\n name：%@",exception.callStackSymbols,exception.reason,exception.name];
    return strLog;
}
@end
