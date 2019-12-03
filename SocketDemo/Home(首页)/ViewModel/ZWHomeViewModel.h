//
//  ZWHomeViewModel.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWHomeViewModel : ZWBaseViewModel
@property(nonatomic,strong) RACCommand *RequestCommand;
@property(nonatomic,strong) RACCommand *RequestMoreCommand;
@property(nonatomic,strong) RACCommand *RequestNoticeCommand;
@property(nonatomic,strong) RACCommand *RequestVersionCommand;
@end

NS_ASSUME_NONNULL_END
