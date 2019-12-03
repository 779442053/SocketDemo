//
//  VideosAdCell.h
//  KuaiZhu
//
//  Created by apple on 2019/5/28.
//  Copyright © 2019 su. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 广告列
 */
@interface VideosAdCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet FLAnimatedImageView *flaADImageView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UILabel *labTitle;
@end

NS_ASSUME_NONNULL_END
