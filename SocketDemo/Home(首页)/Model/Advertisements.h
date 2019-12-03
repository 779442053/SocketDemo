//
//  Advertisements.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Advertisements : NSObject
@property (nonatomic, assign) NSInteger advId;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *cover;

@property (nonatomic,   copy) NSString *url;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;
@end
@interface Advs : NSObject

@property (nonatomic, assign) NSInteger advId;

@property (nonatomic,   copy) NSString *title;

@property (nonatomic,   copy) NSString *cover;

@property (nonatomic,   copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
