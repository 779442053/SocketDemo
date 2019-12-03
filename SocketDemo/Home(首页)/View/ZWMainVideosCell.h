//
//  ZWMainVideosCell.h
//  KuaiZhu
//
//  Created by step_zhang on 2019/11/7.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMainVideosCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *UserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *HeardImageView;

@property (weak, nonatomic) IBOutlet UILabel *NameLB;
@property (weak, nonatomic) IBOutlet UILabel *heardLB;

@property (weak, nonatomic) IBOutlet UILabel *DesLb;

@end

NS_ASSUME_NONNULL_END
