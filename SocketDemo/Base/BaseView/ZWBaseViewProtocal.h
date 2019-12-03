//
//  ZWBaseViewProtocal.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWBaseViewModelProtocol.h"
@protocol ZWBaseViewModelProtocol;
NS_ASSUME_NONNULL_BEGIN

@protocol ZWBaseViewProtocal <NSObject>
@optional
- (instancetype)initWithViewModel:(id<ZWBaseViewModelProtocol>)viewModel;

- (void)zw_bindViewModel;
- (void)zw_setupViews;
- (void)zw_addReturnKeyBoard;
@end

NS_ASSUME_NONNULL_END
