//
//  ZWBaseViewModel.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseViewModel.h"
#import "ZWRequest.h"
@implementation ZWBaseViewModel

@synthesize request  = _request;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ZWBaseViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel zw_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (ZWRequest *)request {
    
    if (!_request) {
        
        _request = [ZWRequest request];
    }
    return _request;
}
@end
