//
//  AppDelegate.h
//  SocketDemo
//
//  Created by step_zhang on 2019/12/3.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;
+ (AppDelegate *)shareAppDelegate;
@end

