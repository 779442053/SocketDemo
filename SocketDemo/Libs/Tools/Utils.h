//
//  Utils.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>
@class FLAnimatedImageView;
NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
/**! 图片不变形处理 */
+(void)imgNoTransformation:(UIImageView *_Nullable)img;

@end

NS_ASSUME_NONNULL_END
