//
//  AnnouncementsModel.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/16.
//  Copyright © 2019年 su. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 首页公告数据模型
 */
@interface AnnouncementsModel : NSObject

@property(nonatomic,assign) NSInteger id;
@property(nonatomic,  copy) NSString *title;
@property(nonatomic,  copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
