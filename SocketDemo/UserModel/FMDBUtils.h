//
//  FMDBUtils.h
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MovieDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface FMDBUtils : NSObject
/** 控制器单例 */
+(instancetype)shareInstance;

/** 初始化数据库和表 */
-(BOOL)initDBAndTables;

/**
 * 查询所有数据
 * @para tbName      NSString     表名
 * @param strWere    NSString     条件语句(可选)
 * @param strOrderBy NSString     排序语句(可选)
 */
- (NSArray *)getAllValuesFromTable:(NSString * _Nonnull)tbName
                          AndWhere:(NSString * _Nullable)strWere
                       WithOrderBy:(NSString * _Nullable)strOrderBy;

/**
 * 根据主键删除信息
 * @param strKey   NSString 主键名
 * @para tbName    NSString 表名
 * @param strV     NSString 主键值
 */
-(BOOL)removeDataForPrimaryKey:(NSString * _Nonnull)strKey
                      AndTable:(NSString * _Nonnull)tbName
                  withKeyValue:(NSString * _Nonnull)strV;

/**
 * 插入数据
 * @param dic   NSDictionary 每个对象为 column:value 构成的键值对
 * @para tbName NSString     表名
 */
-(BOOL)addDataForDic:(NSDictionary * _Nonnull)dic
            AndTable:(NSString * _Nonnull)tbName;

/**
 * 删除表中所有信息
 * @param tbName NSString 表名
 */
-(BOOL)removeAllDataForTableName:(NSString * _Nonnull)tbName;


//MARK: - 添加观看的视频
-(void)addHistoryMoves:(MovieDetailModel * _Nonnull)model;

//MARK: - 添加下载的视频
/**
 * @parma movieid     NSInteger 视频编号
 * @parma strUrl      NSString 视频真实地址
 * @param strLocalurl NSString 视频本地存放地址
 * @parma strTitle    NSString 视频标题
 * @parma strName     NSString 视频名称(带后缀)
 * @parma strCover    NSString 视频封面图片
 */
-(void)addDownloadMovesForId:(NSInteger)movieid
                      andUrl:(NSString * _Nonnull)strUrl
                  andLocaurl:(NSString * _Nonnull)strLocalurl
                    andTitle:(NSString * _Nonnull)strTitle
                 andMovename:(NSString * _Nonnull)strName
                    andCover:(NSString * _Nonnull)strCover
                  withFinish:(BOOL)isFinish;
@end

NS_ASSUME_NONNULL_END
