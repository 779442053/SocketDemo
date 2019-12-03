//
//  ZWBsaeViewcontrollerProtocal.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZWBaseViewModelProtocol;

@protocol ZWBsaeViewcontrollerProtocal <NSObject>
//绑定modelview
- (instancetype)initWithViewModel:(id <ZWBaseViewModelProtocol>)viewModel;
- (void)zw_bindViewModel;
- (void)zw_addSubviews;
- (void)zw_layoutNavigation;
- (void)zw_getNewData;
@end

NS_ASSUME_NONNULL_END
