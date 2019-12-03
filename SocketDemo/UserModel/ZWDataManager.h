//
//  ZWDataManager.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWDataManager : NSObject
/**
 *  保存用户数据
 */
+ (void)saveUserData;

/**
 *  读取用户数据
 */
+ (void)readUserData;

/**
 *  删除用户数据
 */
+ (void)removeUserData;
@end

NS_ASSUME_NONNULL_END
