//
//  VideoModel.h
//  KuaiZhu
//
//  Created by Ghy on 2019/5/9.
//  Copyright © 2019年 su. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Videos, Advertisements, userData;

@interface VideoModel : NSObject

@property (nonatomic, assign) NSInteger resultCode;

@property (nonatomic,   copy) NSString *errorMessage;
/** 广告间隔 */
@property (nonatomic, assign) NSInteger advertisementSpan;

@property (nonatomic, strong) NSArray <Videos *> *videos;

@property (nonatomic, strong) NSArray <Advertisements *> *advertisements;

@property (nonatomic,   copy) NSArray <userData *> *datas;

@end

@interface Videos : NSObject

@property (nonatomic, assign) NSInteger videoId;

@property (nonatomic,   copy) NSString *title;
/** 视频封面 */
@property (nonatomic,   copy) NSString *cover;
/** 视频被收藏次数 */
@property (nonatomic, assign) NSInteger favoriteCount;
/** 视频被点赞次数 */
@property (nonatomic, assign) NSInteger heartCount;
/** 视频被查看次数 */
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger userID;

@property (nonatomic,   copy) NSString *userPhoto;

@property (nonatomic,   copy) NSString *createTime;

@property (nonatomic,   copy) NSString *userName;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL IsVerticalScreen;

@property (nonatomic, assign) CGFloat ItemWidth;
@property (nonatomic, assign) CGFloat ItemHeight;
@end

@interface userData : NSObject

@property (nonatomic, assign) NSInteger fansCount;

@property (nonatomic,   copy) NSString *followid;

@property (nonatomic,   copy) NSString *name;

@property (nonatomic,   copy) NSString *photo;

@property (nonatomic,   copy) NSString *userId;

@property (nonatomic, assign) CGFloat height;
@end
