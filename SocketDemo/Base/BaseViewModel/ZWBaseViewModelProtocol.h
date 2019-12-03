//
//  ZWBaseViewModelProtocol.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWRequest.h"
typedef enum : NSUInteger {
    ZWHeaderRefresh_HasMoreData = 1,
    ZWHeaderRefresh_HasNoMoreData,
    ZWFooterRefresh_HasMoreData,
    ZWFooterRefresh_HasNoMoreData,
    ZWRefreshError,
    ZWRefreshUI,
} ZWRefreshDataStatus;
NS_ASSUME_NONNULL_BEGIN

@protocol ZWBaseViewModelProtocol <NSObject>
- (instancetype)initWithModel:(id)model;

@property (strong, nonatomic)ZWRequest *request;

/**
 *  初始化
 */
- (void)zw_initialize;
@end

NS_ASSUME_NONNULL_END
