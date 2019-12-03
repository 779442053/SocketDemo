//
//  FMDBUtils.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "FMDBUtils.h"
#import "MovieDetailModel.h"
#import "sqlite3.h"
#import "FMDB.h"
#import "FMDBUtils.h"

/** 数据库路径 */
#define K_FMDB_PATH [NSString stringWithFormat:@"%@/AppDBFile.sqlite",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]]
/** 电影观看历史信息表 */
#define K_FMDB_MOVIES_HISTORY_INFO @"moves_history_info"
/** 电影下载信息表 */
#define K_FMDB_MOVIES_DOWNLOAD_INFO @"moves_download_info"
/** 用户登录名信息表 */
#define K_FMDB_USER_LOGIN_INFO @"users_login_info"
@interface FMDBUtils()

@property(nonatomic,strong) FMDatabaseQueue *dataBaseQueue;

@end
@implementation FMDBUtils
static id _shareInstance = nil;
+(instancetype)shareInstance{
    
    if(_shareInstance != nil){
        return _shareInstance;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_shareInstance == nil){
            _shareInstance = [[self alloc] init];
        }
    });
    
    return _shareInstance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _shareInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    
    if(_shareInstance != nil){
        return _shareInstance;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_shareInstance == nil){
            _shareInstance = [super allocWithZone:zone];
        }
    });
    
    return _shareInstance;
}


//MARK: -
/** 关闭数据库（释放）*/
- (void)close{
    if (self.dataBaseQueue) {
        [self.dataBaseQueue close];
        self.dataBaseQueue = nil;
        
        ZWWLog(@"数据库已关闭");
    }
}

/** 初始化数据库和表 */
-(BOOL)initDBAndTables{
    
    __block BOOL isSuccess = FALSE;
    if (!_dataBaseQueue) {
        _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:K_FMDB_PATH];
    }
    //创建表
    NSArray *arrSqls = @[
                         [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS `%@`('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'user_name' TEXT UNIQUE,'user_password' TEXT DEFAULT '');",K_FMDB_USER_LOGIN_INFO],
                         [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('mid' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'id' INTEGER UNIQUE,'cover' TEXT DEFAULT '','downloadName' TEXT DEFAULT '','downloadurl' TEXT DEFAULT '','favoriteCount' INTEGER DEFAULT 0,'isFavorite' TEXT,'isHeart' TEXT,'isFollow' TEXT,'title' TEXT DEFAULT '','url' TEXT DEFAULT '','userID' INTEGER,'userPhoto' TEXT DEFAULT '','viewCount' TEXT DEFAULT '','createTime' TEXT DEFAULT '','commentCount' INTEGER,'followCount' INTEGER,'heartCount' INTEGER,'userName' TEXT DEFAULT '','videoWidth' TEXT DEFAULT '0','videoHeight' TEXT DEFAULT '0','IsVerticalScreen' TEXT DEFAULT '0' );",K_FMDB_MOVIES_HISTORY_INFO],
                         [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'('mid' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'movieid' INTEGER UNIQUE,'cover' TEXT DEFAULT '','downloadurl' TEXT DEFAULT '','localurl' TEXT DEFAULT '','title' TEXT DEFAULT '','move_name' TEXT DEFAULT '','isDownload' TEXT DEFAULT '0');",K_FMDB_MOVIES_DOWNLOAD_INFO]
                         ];
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        for (NSString *strSQL in arrSqls) {
            isSuccess = [db executeUpdate:strSQL];
            //一个没成功就退出
            if (!isSuccess) {
                break;
            }
        }
    }];
    
    return isSuccess;
}


//MARK: - 增、删、改、查
/** 插入数据 */
-(BOOL)addDataForDic:(NSDictionary * _Nonnull)dic
            AndTable:(NSString * _Nonnull)tbName{
    
    if (!dic || [dic count] <= 0 || [[dic allKeys] count] <= 0) {
        return NO;
    }
    
    if (!tbName || [tbName isEqualToString:@""]) {
        return NO;
    }
    
    NSString *strColumns = [NSString stringWithFormat:@"%@",[[dic allKeys] componentsJoinedByString:@","]];
    NSString *strValues = [NSString stringWithFormat:@"'%@'",[[dic allValues] componentsJoinedByString:@"','"]];
    // replace into （insert into 的增强版）如果发现表中已经有此行数据（根据主键或者唯一索引判断）则先删除此行数据，然后插入新的数据。否则，直接插入新数据。
    NSString *strSQL = [NSString stringWithFormat:@"REPLACE INTO `%@`(%@) VALUES(%@);",tbName,strColumns,strValues];
    ZWWLog(@"%@",strSQL);
    
    __block BOOL isOK = NO;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        isOK = [db executeUpdate:strSQL];
    }];
    
    return isOK;
}


/**
 获取所有数据
 @param tbName 表名称
 @return 返回所有数据的数组
 */
- (NSArray *)getAllValuesFromTable:(NSString * _Nonnull)tbName
                          AndWhere:(NSString * _Nullable)strWere
                       WithOrderBy:(NSString * _Nullable)strOrderBy{
    
    if (!tbName || [tbName isEqualToString:@""]) {
        return nil;
    }
    
    __block NSString *strColumnInfo;
    __block NSMutableArray *arrInfo = [NSMutableArray array];
    
    NSString *strSQL = [NSString stringWithFormat:@"SELECT * FROM `%@` %@ %@;",tbName,strWere?strWere:@"",strOrderBy?strOrderBy:@""];
    ZWWLog(@"%@",strSQL);
    
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableDictionary *dicTemp;
        FMResultSet *resultSet = [db executeQuery:strSQL];
        
        while ([resultSet next]) {
            dicTemp = [NSMutableDictionary dictionary];
            
            //遍历所有的列
            for (int i = 0,len = [resultSet columnCount]; i < len; i++) {
                strColumnInfo = [resultSet columnNameForIndex:i];
                
                [dicTemp setValue:[resultSet stringForColumn:strColumnInfo] forKey:strColumnInfo];
            }
            
            //添加到数组
            [arrInfo addObject:dicTemp];
        }
        
        [resultSet close];
    }];
    
    return [arrInfo copy];
}

/** 根据主键删除信息 */
-(BOOL)removeDataForPrimaryKey:(NSString * _Nonnull)strKey
                      AndTable:(NSString * _Nonnull)tbName
                  withKeyValue:(NSString * _Nonnull)strV{
    if (!strKey || [strKey isEqualToString:@""]) {
        return NO;
    }
    
    if (!strV || [strV isEqualToString:@""]) {
        return NO;
    }
    
    if (!tbName || [tbName isEqualToString:@""]) {
        return NO;
    }
    
    __block BOOL isOk = FALSE;
    NSString *strSQL = [NSString stringWithFormat:@"DELETE FROM `%@` WHERE `%@` = ?;",tbName,strKey];
    ZWWLog(@"删除数据：%@",strSQL);
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        isOk = [db executeUpdate:strSQL,strV];
    }];
    
    return isOk;
}

/**
 * 删除表中所有信息
 * @param tbName NSString 表名
 */
-(BOOL)removeAllDataForTableName:(NSString *)tbName{
    
    if (!tbName || [tbName isEqualToString:@""]) {
        return NO;
    }
    
    __block BOOL isOk = FALSE;
    NSString *strSQL = [NSString stringWithFormat:@"DELETE FROM `%@`;",tbName];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        isOk = [db executeUpdate:strSQL];
    }];
    
    return isOk;
}

//MARK: - 添加观看的视频
-(void)addHistoryMoves:(MovieDetailModel *)model{
    if (model) {
        if (![model isKindOfClass:[MovieDetailModel class]]) {
            model = [MovieDetailModel mj_objectWithKeyValues:model];
        }
        
        NSDictionary *dicData = @{
                                  @"id":[NSString stringWithFormat:@"%@",model.movieid],
                                  @"cover":model.cover?model.cover:@"",
                                  @"downloadName":model.downloadName?model.downloadName:@"",
                                  @"downloadurl":model.downloadUrl?model.downloadUrl:@"",
                                  @"favoriteCount":[NSString stringWithFormat:@"%lD",(long)model.favoriteCount],
                                  @"heartCount":[NSString stringWithFormat:@"%lD",(long)model.heartCount],
                                  @"isHeart":[NSString stringWithFormat:@"%lD",(long)model.isHeart],
                                  @"isFavorite":[NSString stringWithFormat:@"%lD",(long)model.isFavorite],
                                  @"isFollow":[NSString stringWithFormat:@"%lD",(long)model.isFollow],
                                  @"title":model.title?model.title:@"",
                                  @"url":model.url?model.url:@"",
                                  @"userID":model.userID?model.userID:@"",
                                  @"userPhoto":model.userPhoto?model.userPhoto:@"",
                                  @"viewCount":[NSString stringWithFormat:@"%lD",(long)model.viewCount],
                                  @"createTime":model.createTime?model.createTime:@"",
                                  @"commentCount":[NSString stringWithFormat:@"%lD",(long)model.commentCount],
                                  @"followCount":[NSString stringWithFormat:@"%lD",(long)model.followCount],
                                  @"userName":model.userName?model.userName:@"",
                                  @"videoWidth":[NSString stringWithFormat:@"%f",model.videoWidth],
                                  @"videoHeight":[NSString stringWithFormat:@"%f",model.videoHeight],
                                  @"IsVerticalScreen":model.IsVerticalScreen?@"1":@"0"
                                  };
        BOOL isOK = [[FMDBUtils shareInstance] addDataForDic:dicData
                                                    AndTable:K_FMDB_MOVIES_HISTORY_INFO];
        ZWWLog(@"记录观看视频历史%@",isOK?@"成功":@"失败");
    }
    else{
        ZWWLog(@"记录观看视频历史失败！数据不存在");
    }
}


//MARK: - 添加下载的视频
-(void)addDownloadMovesForId:(NSInteger)movieid
                      andUrl:(NSString * _Nonnull)strUrl
                  andLocaurl:(NSString * _Nonnull)strLocalurl
                    andTitle:(NSString * _Nonnull)strTitle
                 andMovename:(NSString * _Nonnull)strName
                    andCover:(NSString * _Nonnull)strCover
                  withFinish:(BOOL)isFinish{
    
    /**
     'mid' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
     'movieid' INTEGER UNIQUE,
     'cover' TEXT DEFAULT '',
     'downloadurl' TEXT DEFAULT '',
     'localurl' TEXT DEFAULT '',
     'title' TEXT DEFAULT '',
     'move_name' TEXT DEFAULT '',
     'isDownload' TEXT DEFAULT '0'
     */
    NSDictionary *dicData = @{
                              @"movieid":[NSString stringWithFormat:@"%lD",(long)movieid],
                              @"cover":strCover,
                              @"downloadurl":strUrl,
                              @"localurl":strLocalurl,
                              @"title":strTitle,
                              @"move_name":strName,
                              @"isDownload":isFinish?@"1":@"0"
                              };
    BOOL isOK = [[FMDBUtils shareInstance] addDataForDic:dicData
                                                AndTable:K_FMDB_MOVIES_DOWNLOAD_INFO];
    ZWWLog(@"记录下载视频%@",isOK?@"成功":@"失败");
}
@end
