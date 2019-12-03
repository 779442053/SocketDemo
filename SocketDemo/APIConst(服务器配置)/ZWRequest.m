//
//  ZWRequest.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWRequest.h"
#import "ZWConseKey.h"
#import "YJProgressHUD.h"
#import "ZWMessage.h"
#import "ZWUserModel.h"
@implementation ZWRequest
+(instancetype)request{
    return [[self alloc]init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPSessionManager manager];
        self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    return self;
}
- (void)GETTWO:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(ZWRequest *request, NSDictionary *responseObject))success
    failure:(void (^)(ZWRequest *request, NSError *error))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain, @"application/json",nil];
    [self.operationManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    NSString *str1 = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.operationManager GET:str1 parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        ZWWLog(@"downloadProgress=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        //NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        ZWWLog(@"[ZWRequest请求成功]: %@",[responseObject class]);
        
        success(self,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        ZWWLog(@"[ZWRequest请求失败了]: %@",error.localizedDescription);
        [YJProgressHUD showError:error.localizedDescription];
        if (error.code == -1001) {
            ZWWLog(@"请求超时啦")
            [ZWMessage message:@"请求超时,请稍后再来" title:@"温馨提示"];
        }
        failure(self,error);
    }];
    
}
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(ZWRequest *request, NSDictionary *responseObject))success
    failure:(void (^)(ZWRequest *request, NSError *error))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain, @"application/json",nil];
    [self.operationManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    NSString *URL = [NSString stringWithFormat:@"%@%@",K_APP_HOST,URLString];
    NSString *str1 = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.operationManager GET:str1 parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        ZWWLog(@"downloadProgress=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        //NSString *responseJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        ZWWLog(@"[ZWRequest请求成功]: %@",[responseObject class]);
        
        success(self,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        ZWWLog(@"[ZWRequest请求失败了]: %@",error.localizedDescription);
        [YJProgressHUD showError:error.localizedDescription];
        if (error.code == -1001) {
            ZWWLog(@"请求超时啦")
            [ZWMessage message:@"请求超时,请稍后再来" title:@"温馨提示"];
        }
        failure(self,error);
    }];
    
}

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(ZWRequest *request, NSDictionary* responseString))success
     failure:(void (^)(ZWRequest *request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain, @"application/json",nil];
     [self.operationManager.requestSerializer setValue:LOGIN_COOKIE forHTTPHeaderField:LOGIN_COOKIE_KEY];
    NSString *URL = [NSString stringWithFormat:@"%@%@",K_APP_HOST,URLString];
    ZWWLog(@"请求地址=%@  请求参数=%@",URL,parameters)
    [self.operationManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //ZWWLog(@"uploadProgress=%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        //NSString* responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //ZWWLog(@"[ZWRequest成功]: %@",responseObject);
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时啦")
            [ZWMessage message:@"请求超时,请稍后再来" title:@"温馨提示"];
        }
        ZWWLog(@"[ZWRequest请求失败]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
    
}
- (void)POSTTWO:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(ZWRequest *request, NSDictionary* responseString))success
     failure:(void (^)(ZWRequest *request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain, @"application/json",nil];
    NSString *URL = [NSString stringWithFormat:@"%@%@",K_APP_HOST,URLString];
    ZWWLog(@"请求地址=%@  请求参数=%@",URLString,parameters)
    [self.operationManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //ZWWLog(@"uploadProgress=%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        //NSString* responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //ZWWLog(@"[ZWRequest成功]: %@",responseObject);
        success(self,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            ZWWLog(@"请求超时啦")
            [ZWMessage message:@"请求超时,请稍后再来" title:@"温馨提示"];
        }
        ZWWLog(@"[ZWRequest请求失败]: %@",error.localizedDescription);
        failure(self,error);
        
    }];
    
}

- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    [self POST:URLString
    parameters:parameters
       success:^(ZWRequest *request, NSDictionary *responseString) {
           if ([self.delegate respondsToSelector:@selector(ZWRequest:finished:)]) {
               [self.delegate ZWRequest:request finished:responseString];
               
           }
       }
       failure:^(ZWRequest *request, NSError *error) {
           if ([self.delegate respondsToSelector:@selector(ZWRequest:Error:)]) {
               [self.delegate ZWRequest:request Error:error.description];
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(ZWRequest *request, NSDictionary *responseString) {
        if ([self.delegate respondsToSelector:@selector(ZWRequest:finished:)]) {
            [self.delegate ZWRequest:request finished:responseString];
        }
    } failure:^(ZWRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(ZWRequest:Error:)]) {
            [self.delegate ZWRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}


- (void)upload:(NSString*)URLString withFileData:(NSData*)fileData mimeType:(NSString*)mimeType name:(NSString*)name
    parameters:(NSDictionary*)parameters
       success:(void (^)(ZWRequest *request, NSDictionary* responseString))success
       failure:(void (^)(ZWRequest *request, NSError *error))failure
{
    self.operationQueue=self.operationManager.operationQueue;
    //self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain,@"application/json", nil];
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *URL = [[NSUserDefaults standardUserDefaults]objectForKey:AppUrlUploadFile];
    if ( !URL || URL.length == 0) {
        [YJProgressHUD showError:@"没有获取到上传路径"];
    }
    //NSString *URL = [NSString stringWithFormat:@"%@%@",HTURL,URLString];
    
    
    
    [self.operationManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name fileName:name mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
         ZWWLog(@"上传进度=%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         success(self,responseObject);
        ZWWLog(@"============上传成功啦==========")
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(self,error);
        ZWWLog(@"===上传失败啦===上传失败啦====上传失败啦")
    }];
    
}
- (void)uploadFile:(NSString*)URLString withFileData:(NSData*)fileData mimeType:(NSString*)mimeType name:(NSString*)name
    parameters:(NSDictionary*)parameters
       success:(void (^)(ZWRequest *request, NSDictionary* responseString))success
       failure:(void (^)(ZWRequest *request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:RequestContentTypeText,RequestContentTypeJson,RequestContentTypePlain,@"application/json", nil];
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *URL = [[NSUserDefaults standardUserDefaults]objectForKey:AppUrlUploadFile];
    if ( !URL || URL.length == 0) {
        [YJProgressHUD showError:@"没有获取到上传路径"];
    }
    [self.operationManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //当前时间戳
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%.0f.%@", timestamp, name];
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ZWWLog(@"上传进度=%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         ZWWLog(@"============上传成功啦==========")
        success(self,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZWWLog(@"===上传失败啦===上传失败啦====上传失败啦")
        failure(self,error);
    }];
}

- (void)uploadMoreFile:(NSString*)URLString withFileDataARR:(NSMutableArray*)fileDataARR mimeType:(NSString*)mimeType nameARR:(NSMutableArray*)nameARR
        parameters:(NSDictionary*)parameters
           success:(void (^)(ZWRequest *request, NSDictionary* responseString))success
           failure:(void (^)(ZWRequest *request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];//声明返回的结果是json类型
    self.operationManager.requestSerializer.timeoutInterval = 8.f;
    [self.operationManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *URL = [NSString stringWithFormat:@"%@%@",K_APP_HOST,URLString];
    [self.operationManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileDataARR.count; i++){
//            ZWWLog(@"=nameARR==%@",fileDataARR[i])
//            ZWWLog(@"=nameARR==%@",nameARR[i])
            NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
            NSString *fileName = [NSString stringWithFormat:@"%.0f.%@", timestamp, nameARR[i]];
            [formData appendPartWithFileData:fileDataARR[i] name:nameARR[i] fileName:fileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ZWWLog(@"上传进度=%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZWWLog(@"============上传成功啦==========")
        success(self,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZWWLog(@"===上传失败啦===上传失败啦====上传失败啦=%@",[error description])
        failure(self,error);
    }];
}
@end
