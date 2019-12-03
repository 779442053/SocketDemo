//
//  ZWHomeViewModel.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWHomeViewModel.h"
#import "AnnouncementsModel.h"
#import "VideoModel.h"
@interface ZWHomeViewModel()
@property(nonatomic, assign) NSInteger  lastId;
@property(nonatomic, assign) NSInteger  lastAid;
@property(nonatomic, assign) BOOL hasNextPage; //是否加载更多
@property(nonatomic, assign) NSInteger pIndex; //页码
@end
@implementation ZWHomeViewModel
-(void)zw_initialize{
    self.pIndex = 0;       //默认第一页
    self.lastId = 0;
    self.lastAid = 0;
    self.hasNextPage = NO;
    @weakify(self)
    self.RequestVersionCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSMutableDictionary *dict) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSString *strUrl = @"Version";
            NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
            parma[@"d"] = @"IOS";
            [self.request GET:strUrl parameters:parma success:^(ZWRequest *Request, NSDictionary *resDict) {
                [YJProgressHUD hideHUD];
                ZWWLog(@"版本信息==：%@",resDict);
                NSString *version = resDict[@"version"];
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *Currentversion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                //Bundle version
                NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
                ZWWLog(@"=程序员版本号=\n=%@    =\n服务器=%@  对外展示版本=\n%@",app_build,version,Currentversion)
                ZWWLog(@"=本地==%f    =服务器=%f",[app_build floatValue],[version floatValue])
                [subscriber sendNext:@{@"code":@"0",@"version":version,@"Currentversion":Currentversion,@"app_build":app_build,@"info":resDict[@"info"],@"url":resDict[@"url"]}];
                [subscriber sendCompleted];
            } failure:^(ZWRequest *Request, NSError *error) {
                [YJProgressHUD hideHUD];
                [YJProgressHUD showError:ZWerror];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }];
    
    self.RequestNoticeCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSMutableDictionary *dict) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            NSString *strUrl = @"Announcements";
            NSMutableDictionary *parma = [[NSMutableDictionary alloc]init];
            parma[@"id"] = @"0";
            [self.request GET:strUrl parameters:parma success:^(ZWRequest *Request, NSDictionary *resDict) {
                [YJProgressHUD hideHUD];
                if ([resDict[code] intValue] == 0) {
                   NSArray *tmpArr = resDict[@"data"];
//                   NSArray *arr = [AnnouncementsModel
//                                        mj_keyValuesArrayWithObjectArray:tmpArr];
                    [subscriber sendNext:@{@"code":@"0",@"res":@""}];
                    [subscriber sendCompleted];
                }else{
                    [YJProgressHUD showError:resDict[msg]];
                    [subscriber sendNext:@{@"code":@"1",@"result":resDict[msg]}];
                    [subscriber sendCompleted];
                }
            } failure:^(ZWRequest *Request, NSError *error) {
                [YJProgressHUD hideHUD];
                [YJProgressHUD showError:ZWerror];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }];
    }];
    
    self.RequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString * input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            self.pIndex = 0;
            NSString *strUrl = [self getUrlStringIsrefresh:input];
            NSDictionary *dicParams = @{
            @"p":[NSString stringWithFormat:@"%lD",(long)self.pIndex],
            @"v":[NSString stringWithFormat:@"%lD",(long)self.lastId]
            };
            [self.request GET:strUrl parameters:dicParams success:^(ZWRequest *request, NSDictionary *responseString) {
//                VideoModel *model = [VideoModel mj_objectWithKeyValues:responseString];
                NSMutableArray *totalArray = [[NSMutableArray alloc]init];
//                [Utils mergeData:model.advertisements
//                  AndInterval:model.advertisementSpan
//                  andListData:model.videos
//                withTotalData:totalArray];
//                self.hasNextPage = [model.videos count] > 0?YES:NO;
                [subscriber sendNext:@{@"code":@"0",@"res":totalArray}];
                [subscriber sendCompleted];
            } failure:^(ZWRequest *request, NSError *error) {
                [YJProgressHUD showError:ZWerror];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    self.RequestMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString * input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            self.pIndex += 1;
            NSString *strUrl = [self getUrlStringIsrefresh:input];
            NSDictionary *dicParams = @{
            @"p":[NSString stringWithFormat:@"%lD",(long)self.pIndex],
            @"v":[NSString stringWithFormat:@"%lD",(long)self.lastId]
            };
            [self.request GET:strUrl parameters:dicParams success:^(ZWRequest *request, NSDictionary *responseString) {
//                VideoModel *model = [VideoModel mj_objectWithKeyValues:responseString];
                NSMutableArray *totalArray = [[NSMutableArray alloc]init];
//                [Utils mergeData:model.advertisements
//                  AndInterval:model.advertisementSpan
//                  andListData:model.videos
//                withTotalData:totalArray];
//                self.hasNextPage = [model.videos count] > 0?YES:NO;
                [subscriber sendNext:@{@"code":@"0",@"res":@""}];
                [subscriber sendCompleted];
            } failure:^(ZWRequest *request, NSError *error) {
                [YJProgressHUD showError:ZWerror];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
}
-(NSString *)getUrlStringIsrefresh:(NSString *)strType{
    //最热==默认最热 VideoHotestPage
    NSString *strUrl = @"Staticize/VideoHotestPage";
    if ([strType isEqualToString:@"最热"]) {
        //只有静态接口
        strUrl = @"Staticize/VideoFindPage";
    }
    else if([strType isEqualToString:@"最新"]){
        strUrl = @"Staticize/VideoLatestPage";
    }
    ///VideoHotestPage
    return strUrl;
}
@end
