//
//  LuanchADModel.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LuanchADModel : NSObject
/** 启动广告模型 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic,   copy) NSString *url;
@property (nonatomic,   copy) NSString *Address;
@end

NS_ASSUME_NONNULL_END
