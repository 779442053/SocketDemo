//
//  MovieDetailModel.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PlayAdvData,AdvData;
@interface MovieDetailModel : ZWBaseModel
@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic,   copy) NSString *serverUrl;

@property (nonatomic,   copy) NSString *errorMessage;
//封面
@property (nonatomic,   copy) NSString *cover;
//视频下载名称，原上传文件的名称
@property (nonatomic,   copy) NSString *downloadName;
//视频下载地址，返回的数据为相对地址，实际地址的获取规则同视频播放地址
@property (nonatomic,   copy) NSString *downloadUrl;

//视频被收藏(喜欢)次数
@property (nonatomic, assign) NSInteger favoriteCount;
//视频数据编号
@property (nonatomic,   copy) NSString *movieid;

@property (nonatomic,   copy) NSString *shareVideoUrl;
@property (nonatomic,   copy) NSString *shareWinXinUrl;
@property (nonatomic,   copy) NSString *shareQQUrl;
@property (nonatomic,   copy) NSString *shareWXLimitTips;

@property (nonatomic, assign) NSInteger isFavorite;           //是否收藏

@property (nonatomic, assign) NSInteger isFollow;            //是否关注发布者

@property (nonatomic,assign) NSInteger isHeart;             //是否设置喜欢
@property (nonatomic,assign) NSInteger heartCount;

@property (nonatomic,assign) NSInteger isShort;          //是否为短视频，用户通过 app 端上传的视频均为短视 频

@property (nonatomic,   copy) NSString *title;             //视频标题

@property (nonatomic,   copy) NSString *url;              //视频播放地址

@property (nonatomic,   copy) NSString *userID;           //发布者ID

@property (nonatomic,   copy) NSString *userPhoto;          //用户头像

@property (nonatomic,   copy) NSString *userName;          //用户头像

@property (nonatomic, assign) NSInteger viewCount;

@property (nonatomic,   copy) NSString *createTime;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) NSInteger followCount;

//视频播放前的广告信息
@property (nonatomic,  copy) NSDictionary *playAdv;
//广告信息，展示在视频下面，没有视频类型的广告
@property (nonatomic,  copy) NSDictionary *adv;

@property (nonatomic, assign) CGFloat videoHeight;
@property (nonatomic, assign) CGFloat videoWidth;
@property (nonatomic, assign) BOOL IsVerticalScreen;

@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;

@end
/** 视频播放前的广告信息 */
@interface PlayAdvData : NSObject
@property(nonatomic,  copy) NSString *cover;
@property(nonatomic,assign) NSInteger playadvId;
@property(nonatomic,assign) NSInteger playTime;
@property(nonatomic,assign) NSInteger resType;
@property(nonatomic,  copy) NSString *title;
@property(nonatomic,  copy) NSString *url;
@end
/** 视频播放前的广告信息 */
@interface AdvData : NSObject
@property(nonatomic,  copy) NSString *cover;   //广告图片或视频
@property(nonatomic,assign) NSInteger advId;
@property(nonatomic,assign) NSInteger playTime;//广告播放时间
@property(nonatomic,assign) NSInteger resType; //广告文件类型 1 图片 2 视频
@property(nonatomic,  copy) NSString *title;
@property(nonatomic,  copy) NSString *url;     //广告链接地址
@end

NS_ASSUME_NONNULL_END
