//
//  AppDelegate.m
//  SocketDemo
//
//  Created by step_zhang on 2019/12/3.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+ZWWAppDelegate.h"
#import "ZWDataManager.h"
#import "ZWUserModel.h"
#import <AFNetworking/AFNetworking.h>
#import<CoreTelephony/CTCellularData.h>
#import "HomeViewController.h"
@interface AppDelegate ()
@property (strong,nonatomic) Reachability* reachablity;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];
    self.window.rootViewController = self.navigation;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
     [ZWDataManager saveUserData];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [ZWDataManager saveUserData];
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //取消下载
    [mgr cancelAll];
    //清空缓存
    [mgr.imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}
+(AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(UINavigationController *)navigation{
    if (!_navigation) {
        //导航视图==首页
        HomeViewController *homeVC = [[HomeViewController alloc]init];
        _navigation = [[UINavigationController alloc] init];
        [_navigation pushViewController:homeVC animated:NO];
        [_navigation.navigationBar setHidden:YES];
        [_navigation.toolbar setHidden:YES];
    }
    return _navigation;
}




@end
