//
//  HomeListCollectionViewController.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeListCollectionViewController : UICollectionViewController
-(instancetype)initWithType:(NSString *)strType;
@property(nonatomic, weak) HomeViewController *delegateVC;
@end

NS_ASSUME_NONNULL_END
