//
//  ZWUserModel.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWUserModel : ZWBaseModel<NSCoding>
@property(nonatomic,copy)NSString *followCount;//关注粉丝数量
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *name;//昵称
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *videoCount;//发布视频数量
@property(nonatomic,copy)NSString *isFollowed;//是否关注
@property(nonatomic,copy)NSString *fansCount;//粉丝数量
@property(nonatomic,copy)NSString *favoriteCount;//收藏数量
@property(nonatomic,copy)NSString *heartCount;//点赞数量
@property(nonatomic,copy)NSString *alipayAccount;//支付宝账户
@property(nonatomic,copy)NSString *alipayUser;
@property(nonatomic,copy)NSString *weChatAccount;
@property(nonatomic,copy)NSString *weChatUser;
@property(nonatomic,copy)NSString *bankAccount;
@property(nonatomic,copy)NSString *bank;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,copy)NSString *profit;//收益
@property(nonatomic,copy)NSString *frozen;//冻结金额
@property(nonatomic,copy)NSString *auditMoney;//审核金额
@property(nonatomic,copy)NSString *isDownload;//是否开启下载 0未开启 1开启
@property(nonatomic,  copy) NSString *LoginCookie; 
+ (instancetype)currentUser;
@end

NS_ASSUME_NONNULL_END
