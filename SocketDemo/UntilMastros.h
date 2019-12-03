//
//  UntilMastros.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#ifndef UntilMastros_h
#define UntilMastros_h

//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController

//获取屏幕宽高
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds]

//屏幕适配==6s 做的适配
#define kRealValueWidth(with) (with)*KScreenWidth/375.0
#define kRealValueHeight(height) (height)*KScreenHeight/667.0
////根据ip6的屏幕来拉伸===
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

#define K_APP_ISIOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
#define K_APP_ISIPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ZWiPhoneX (K_APP_ISIOS11 && K_APP_ISIPHONE && (MIN(KScreenWidth,KScreenHeight) >= 375 && MAX(KScreenWidth,KScreenHeight) >= 812))/** 判断设备类型是否iPhoneX*/

#define ZWStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/// navigation bar
#define ZWNavBarHeight self.navigationController.navigationBar.frame.size.height
///  Status bar & navigation bar height
#define ZWStatusAndNavHeight (ZWStatusBarHeight + ZWNavBarHeight)

#define  ZWTabbarSafeBottomMargin (ZWiPhoneX ? 34.f : 0.f)

#define ZW(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ZWWWeakSelf(type)  __weak typeof(type) weak##type = type;
#define ZWWStrongSelf(type) __strong typeof(type) type = weak##type;
// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言K
#define KCurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])
//APP版本号
#define KAPP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ZWWOBJECT_IS_EMPYT(object) \
({ \
BOOL flag = NO; \
if ([object isKindOfClass:[NSNull class]] || object == nil || object == Nil || object == NULL) \
flag = YES; \
if ([object isKindOfClass:[NSString class]]) \
if ([(NSString *)object length] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSArray class]]) \
if ([(NSArray *)object count] < 1) \
flag = YES; \
if ([object isKindOfClass:[NSDictionary class]]) \
if ([(NSDictionary *)object allKeys].count < 1) \
flag = YES; \
(flag); \
})

#ifdef DEBUG
#define ZWWLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ZWWLog(...)
#endif

#define READ_USER_DATA_FINISH @"readUserDataFinish"
#define K_APP_CONFIG_KEY @"app_config_key"
#define AppUrlUploadFile @"AppUrlUploadFile"
#define K_APP_HOST ([[NSUserDefaults standardUserDefaults] stringForKey:K_APP_CONFIG_KEY]?[[NSUserDefaults standardUserDefaults] stringForKey:K_APP_CONFIG_KEY]:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"AppConfigUrl"])

#define K_APP_BUGLY_APP_ID @"ac84635c29"
#define K_APP_BUGLY_APP_KEY @"60ff1d02-b91b-4b11-8214-f84280e704e4"
#define K_APP_LAUNCH_AD_DATA @"app_launch_ad_data"
#define K_APP_SHARE_INFO @"platform=IOS"


//获取在不同屏幕上的真实高度
#define kRealValueHeight_S(width) (width)*465.0/260.0
#define kRealValueHeight_H(width) (width)*290.0/260.0
#define LOGIN_COOKIE_KEY @"Cookie"
#define LOGIN_COOKIE [ZWUserModel currentUser].LoginCookie
static CGFloat const cell_margin = 3;
#endif /* UntilMastros_h */
