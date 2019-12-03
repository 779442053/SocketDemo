//
//  ZWDataManager.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWDataManager.h"
#import <objc/runtime.h>
#import "ZWUserModel.h"
@implementation ZWDataManager
/**
 *用户数据路径
 */
NSString * const kUserPath = @"Documents/user.plist";
+ (void)saveUserData
{
    if([NSKeyedArchiver archiveRootObject:[ZWUserModel currentUser] toFile:[NSHomeDirectory() stringByAppendingPathComponent:kUserPath]])
    {
        ZWWLog(@"用户数据保存成功");
    }
}
///删除
+ (void)removeUserData
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);

    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:kUserPath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        ZWWLog(@"没有这个文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            ZWWLog(@"删除成功");
        }else {
            ZWWLog(@"删除失败");
        }

    }
}

///读取数据
+ (void)readUserData
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        NSString *userPath = [NSHomeDirectory() stringByAppendingPathComponent:kUserPath];
        NSError *userError;
        NSData *userData = [NSData dataWithContentsOfFile:userPath options:NSDataReadingMappedIfSafe error:&userError];
        if (!userError)
        {
            ZWUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            [self setObj:[ZWUserModel currentUser] fromObj:user];
            //发出下面的通知,是为了让tabbaritem上面显示bagevual
            [[NSNotificationCenter defaultCenter] postNotificationName:READ_USER_DATA_FINISH object:nil];
            ZWWLog(@"读取用户数据成功");
        }
    });
}

// obj1所有属性赋值给obj2   利用runtime
+ (void)setObj:(id)toObj
       fromObj:(id)fromObj
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([toObj class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t pro = propertyList[i];

        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];

        if ([fromObj valueForKey:key])
        {
            [toObj setValue:[fromObj valueForKey:key] forKey:key];
        }
    }
}
@end
