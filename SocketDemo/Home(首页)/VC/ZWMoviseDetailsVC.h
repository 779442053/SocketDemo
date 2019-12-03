//
//  ZWMoviseDetailsVC.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class MovieDetailModel;
@protocol MoviesDetailsVCDelegate <NSObject>

@optional
/** 点赞(取消点赞)视频 */
-(void)moviesDetailsHeartUpdateActionForValue:(NSInteger)_cvalue
                                 AndIndexPath:(NSIndexPath *_Nonnull)_indexPath;

@end
@interface ZWMoviseDetailsVC : ZWBaseViewController
/** 视频链接 */
@property (nonatomic,copy,nonnull) NSString *movieUrl;

/** 视频id */
@property (nonatomic,assign) NSInteger videoId;

@property (nonatomic, assign) BOOL IsVerticalScreen;

/** 进入当前视图的数据索引 */
@property (nonatomic,strong,nullable) NSIndexPath *indexPath;

@property (nonatomic,strong,nullable) MovieDetailModel *movieModel;

@property (nonatomic, strong) UITableView * _Nullable refreshTableView;    //列表
/** 逆向传值更新视频点击的列表(可选) */
@property (nonatomic, weak, nullable) id<MoviesDetailsVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
