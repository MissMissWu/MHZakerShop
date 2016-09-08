//
//  MHHttpTool.m
//  MHNetworking
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MHHttpTool.h"

#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD+MH.h"


// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define MHAppLog(...) NSLog(__VA_ARGS__)
#else
#define MHAppLog(...)
#endif





#import <CommonCrypto/CommonDigest.h>
@interface NSString (md5)

+ (NSString *)mh_networking_md5:(NSString *)string;

@end

@implementation NSString (md5)

+ (NSString *)mh_networking_md5:(NSString *)string
{
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end









/**
 * 网络提示 -- 失去连接  发请求那里
 */
NSString * const MHDidNotHaveNetworkAlertMessage = @"网络不可用";

/**
 *  连接服务器失败
 */
NSString * const MHDidUnConnectWebServiceAlertMessage = @"连接服务器失败,请稍后重试";

/**
 * 网络提示 --当网络突然失去连接
 */
NSString * const MHDidUnConnectNetworkAlertMessage = @"当前网络不可用,请检查网络设置";


//请求网络的方式
typedef enum : NSUInteger
{
    MHRequestHttpGet = 1, //网络请求为Get
    MHRequestHttpPost = 2,//网络请求为Post
} MHRequestHttpType;


#pragma mark - 全局变量 App不销毁 将一直在内存中
/** 请求基础基本Url */
static NSString *privateNetworkBaseUrl_ = nil;
/** 是否需要开启调试数据 默认是NO */
static BOOL isEnableInterfaceDebug_ = NO;
/** 是否需要自动编码 默认是NO */
static BOOL shouldAutoEncode_ = NO;
/** 请求头 */
static NSDictionary *httpHeaders_ = nil;
/** 默认是返回格式是 JSON */
static MHResponseType responseType_ = kMHResponseTypeJSON;
/** 默认请求格式是 JSON*/
static MHRequestType  requestType_  = kMHRequestTypeJSON;
/** 当前网络状态 默认是 未知网络*/
static MHNetworkReachabilityStatus networkStatus_ = MHNetworkReachabilityStatusUnknown;

/** 网络管理器 */
static AFHTTPSessionManager *sharedManager_ = nil;
/** URL 改变*/
static BOOL isBaseURLChanged_ = YES;
/** 请求超时 默认是 60s */
static NSTimeInterval timeout_ = 60.0f;
/** 存储着所有的 请求队列 */
static NSMutableArray *requestTasks_ = nil;
/** 缓存get请求数据 默认是 YES */
static BOOL cacheGetData_ = YES;
/** 缓存Post请求数据 默认是 NO*/
static BOOL cachePostData_ = NO;
/** 是否当request cancel的时候的是否需要回调*/
static BOOL shouldCallbackOnCancelRequest_ = YES;
/** 限制的缓存大小 */
static NSUInteger maxCacheSize_ = 0;
/** 是否当网络失去连接的时候获取本地的缓存数据 默认是 NO*/
static BOOL shouldObtainLocalWhenNetworkUnconnected_ = NO;


@implementation MHHttpTool

// 加载类的时候调用
// 当程序一启动的时候就会调用
+ (void)load
{
    MHAppLog(@"%@ load",[self class]);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 尝试清除缓存
        if (maxCacheSize_ > 0 && [self totalCacheSize] > 1024 * 1024 * maxCacheSize_)
        {
            [self clearCaches];
        }
    });
}

#pragma mark - ------------  Public API  -----------
#pragma mark - 是否当网络失去连接的时候获取本地的缓存数据
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain
{
    shouldObtainLocalWhenNetworkUnconnected_ = shouldObtain;
}

#pragma mark - 设置超时时间
+ (void)setTimeout:(NSTimeInterval)timeout
{
    timeout_ = timeout;
}

#pragma mark - 更新基础Url
+ (void)updateRequestBaseUrl:(NSString *)baseUrl
{
    //TODO: Mike 这里是否原作者  写反了
    if (baseUrl.length && baseUrl && ![baseUrl isEqualToString:privateNetworkBaseUrl_])
    {
        isBaseURLChanged_ = YES;
    }else{
        isBaseURLChanged_ = NO;
    }
    privateNetworkBaseUrl_ = baseUrl;
}
+ (NSString *)baseUrl
{
    return privateNetworkBaseUrl_;
}




#pragma mark - 开启调试
+ (void)enableInterfaceDebug:(BOOL)isDebug
{
    isEnableInterfaceDebug_ = isDebug;
}
+ (BOOL)_isDebug
{
    return isEnableInterfaceDebug_;
}



#pragma mark - 初始化返回数据的格式 以及请求格式  和是否编码
+ (void)configRequestType:(MHRequestType)requestType
             responseType:(MHResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest
{
    requestType_  = requestType;
    responseType_ = responseType;
    shouldAutoEncode_ = shouldAutoEncode;
    shouldCallbackOnCancelRequest_ = shouldCallbackOnCancelRequest;
}

//  是否需要自动编码
+ (BOOL)_shouldAutoEncode
{
    return shouldAutoEncode_;
}


#pragma mark - 配置请求头
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders
{
    httpHeaders_ = httpHeaders;
}

#pragma mark - 清除所有缓存
+ (void)clearCaches
{
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error)
        {
            MHAppLog(@"MHNetworking clear caches error: 【 %@ 】", error.localizedDescription);
        } else {
            MHAppLog(@"MHNetworking clear caches ok");
        }
    }
}
#pragma mark - 所有缓存
+ (unsigned long long)totalCacheSize
{
    NSString *directoryPath = cachePath();
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

#pragma mark - 超过限制的缓存大小 自动设置清除缓存 
+ (void)autoClearCacheWithLimitSize:(NSUInteger)limitSize
{
    maxCacheSize_ = limitSize;
}

#pragma mark - 配置 是否需要缓存 get 和 POST 数据
+ (void)cacheGetRequestData:(BOOL)isCacheGet shouldCachePostData:(BOOL)isCachePost
{
    cacheGetData_ =  isCacheGet;
    cachePostData_ = isCachePost;
}




#pragma mark - 创建请求数组
+ (NSMutableArray *)_allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks_ == nil) {
            requestTasks_ = [[NSMutableArray alloc] init];
        }
    });
    
    return requestTasks_;
}
#pragma mark - 取消所有的网络请求
+ (void)cancelAllRequest
{
    @synchronized(self) {
        [[self _allTasks] enumerateObjectsUsingBlock:^(MHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[MHURLSessionTask class]])
            {
                [task cancel];
            }
        }];
        
        [[self _allTasks] removeAllObjects];
    };
}

#pragma mark - 取消某个请求
+ (void)cancelRequestWithURL:(NSString *)url
{
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self _allTasks] enumerateObjectsUsingBlock:^(MHURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[MHURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self _allTasks] removeObject:task];
                return;
            }
        }];
    };
}

#pragma mark - Get请求
+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(MHResponseSuccess)success
                         failure:(MHResponseFailure)failure
{
    return [self getWithUrl:url refreshCache:refreshCache params:nil success:success failure:failure];
}

+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(MHResponseSuccess)success
                         failure:(MHResponseFailure)failure
{
    return [self getWithUrl:url refreshCache:refreshCache params:params progress:nil success:success failure:failure];
}

+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(MHGetProgress)progress
                         success:(MHResponseSuccess)success
                         failure:(MHResponseFailure)failure
{
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:MHRequestHttpGet
                          params:params
                        progress:progress
                         success:success
                         failure:failure];
}

#pragma mark - Post请求
+ (MHURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(MHResponseSuccess)success
                           failure:(MHResponseFailure)failure
{
    return [self postWithUrl:url refreshCache:refreshCache params:params progress:nil success:success failure:failure];
}

+ (MHURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(MHPostProgress)progress
                          success:(MHResponseSuccess)success
                          failure:(MHResponseFailure)failure
{
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:MHRequestHttpPost
                          params:params
                        progress:progress
                         success:success
                         failure:failure];
}





#pragma mark - 私有请求方式  承载Get和Post 请求  全局修改这个
+ (MHURLSessionTask *)_requestWithUrl:(NSString *)url
                         refreshCache:(BOOL)refreshCache
                             httpMedth:(MHRequestHttpType)httpMethod
                                params:(NSDictionary *)params
                              progress:(MHDownloadProgress)progress
                               success:(MHResponseSuccess)success
                               failure:(MHResponseFailure)failure
{
    // 是否需要编码
    if ([self _shouldAutoEncode])
    {
        url = [self _encodeUrl:url];
    }
    
    // 获取网络管理
    AFHTTPSessionManager *manager = [self _manager];
    
    // 获取全路径Url
    NSString *absolute = [self _absoluteUrlWithPath:url];
    
    
    if ([self baseUrl] == nil)
    {
        if ([NSURL URLWithString:url] == nil)
        {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else
    {
        if ([NSURL URLWithString:absolute] == nil)
        {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    
    // 请求队列
    MHURLSessionTask *session = nil;
    
    // 发送请求
    if (httpMethod == MHRequestHttpGet)  // GET
    {
        if (cacheGetData_)  //获取缓存数据
        {
            if (shouldObtainLocalWhenNetworkUnconnected_)
            {
                if (networkStatus_ == MHNetworkReachabilityStatusUnknown ||
                    networkStatus_ == MHNetworkReachabilityStatusNotReachable )
                {
                    //从本地获取 获取缓存
                    id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                    
                    if (responseObject)
                    {
                        if (success)
                        {
                            // 回调+解析数据
                            [self _successDataWithResponseObject:responseObject callback:success];
                            
                            if ([self _isDebug])
                            {
                                // 打印数据
                                [self _logWithSuccessResponseObject:responseObject
                                                                url:absolute
                                                             params:params];
                            }
                        }
                        
                        return nil;
                    }
                }
            }
            
            if (!refreshCache)   // 从缓存里面获取数据
            {
                // 获取缓存
                //从本地获取 获取缓存
                id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                
                if (responseObject)
                {
                    if (success)
                    {
                        // 回调+解析数据
                        [self _successDataWithResponseObject:responseObject callback:success];
                        
                        if ([self _isDebug])
                        {
                            // 打印数据
                            [self _logWithSuccessResponseObject:responseObject
                                                            url:absolute
                                                         params:params];
                        }
                    }
                    
                    return nil;
                }
            }
        }
        
        session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress)
            {   // 回调请求进度
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 解析 responseObject
            [self _successDataWithResponseObject:responseObject callback:success];

            if (cacheGetData_)
            {
                // 缓存get数据
                [self _cacheDataWithResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            // 移除网络请求
            [[self _allTasks] removeObject:task];
            
            // 打印输出成功的日志
            if ([self _isDebug])
            {
                [self _logWithSuccessResponseObject:responseObject
                                                url:absolute
                                             params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // 移除网络请求
            [[self _allTasks] removeObject:task];
            
            MHAppLog(@" Get--网络请求错误码--- 【 %zd 】" ,error.code);
            
            if ([error code] < 0 && cacheGetData_)
            {
                //从本地获取 获取缓存
                id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                
                if (responseObject)
                {
                    if (success)
                    {
                        // 回调+解析数据
                        [self _successDataWithResponseObject:responseObject callback:success];
                        
                        if ([self _isDebug]) {
                            // 打印数据
                            [self _logWithSuccessResponseObject:responseObject
                                                            url:absolute
                                                         params:params];
                        }
                    }
                } else {
                    [self _handleCallbackWithError:error failure:failure];
                    
                    //8.打印输出错误日志
                    if ([self _isDebug])
                    {
                        [self _logWithFailureError:error url:task.response.URL.absoluteString params:params];
                    }
                }
            } else
            {
                [self _handleCallbackWithError:error failure:failure];
                
                //8.打印输出错误日志
                if ([self _isDebug])
                {
                    [self _logWithFailureError:error url:task.response.URL.absoluteString params:params];
                }
            }
        }];
    } else if (httpMethod == MHRequestHttpPost) // POST 请求方式
    {
        if (cachePostData_)  //获取缓存数据
        {
            if (shouldObtainLocalWhenNetworkUnconnected_)
            {
                if (networkStatus_ == MHNetworkReachabilityStatusUnknown ||
                    networkStatus_ == MHNetworkReachabilityStatusNotReachable )
                {
                    //从本地获取 获取缓存
                    id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                    
                    if (responseObject)
                    {
                        if (success)
                        {
                            // 回调+解析数据
                            [self _successDataWithResponseObject:responseObject callback:success];
                            
                            if ([self _isDebug])
                            {
                                // 打印数据
                                [self _logWithSuccessResponseObject:responseObject
                                                                url:absolute
                                                             params:params];
                            }
                        }
                        
                        return nil;
                    }
                }
            }
            
            if (!refreshCache)   // 从缓存里面获取数据
            {
                // 获取缓存
                //从本地获取 获取缓存
                id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                
                if (responseObject)
                {
                    if (success)
                    {
                        // 回调+解析数据
                        [self _successDataWithResponseObject:responseObject callback:success];
                        
                        if ([self _isDebug])
                        {
                            // 打印数据
                            [self _logWithSuccessResponseObject:responseObject
                                                            url:absolute
                                                         params:params];
                        }
                    }
                    
                    return nil;
                }
            }
        }
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress)
            {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            // 解析数据
            [self _successDataWithResponseObject:responseObject callback:success];
            
            // 移除网络请求
            [[self _allTasks] removeObject:task];
            
            
            if (cachePostData_)
            {
                // 缓存POST数据
                [self _cacheDataWithResponseObject:responseObject request:task.currentRequest parameters:params];
            }
            
            if ([self _isDebug])
            {
                [self _logWithSuccessResponseObject:responseObject
                                                url:absolute
                                             params:params];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            // 移除网络请求
            [[self _allTasks] removeObject:task];
            
            MHAppLog(@" Post--网络请求错误码--- 【 %zd 】" ,error.code);
            
            if ([error code] < 0 && cachePostData_)
            {
                //从本地获取 获取缓存
                id responseObject = [self _getCahceResponseObjectWithURL:absolute parameters:params];
                
                if (responseObject)
                {
                    if (success)
                    {
                        // 回调+解析数据
                        [self _successDataWithResponseObject:responseObject callback:success];
                        
                        if ([self _isDebug]) {
                            // 打印数据
                            [self _logWithSuccessResponseObject:responseObject
                                                            url:absolute
                                                         params:params];
                        }
                    }
                } else {
                    [self _handleCallbackWithError:error failure:failure];
                    
                    //8.打印输出错误日志
                    if ([self _isDebug])
                    {
                        [self _logWithFailureError:error url:task.response.URL.absoluteString params:params];
                    }
                }
            } else
            {
                [self _handleCallbackWithError:error failure:failure];
                
                //8.打印输出错误日志
                if ([self _isDebug])
                {
                    [self _logWithFailureError:error url:task.response.URL.absoluteString params:params];
                }
            }

        }];
    }
    
    
    if (session)
    {
        // 存储请求
        [[self _allTasks] addObject:session];
    }
    
    return session;
}



#pragma mark - 检测网络状态
+ (void)checkNetworkReachabilityStatusBlock:(MHNetworkingReachabilityStatus)statusChangeBlock
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 当网络状态改变了，就会调用
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        MHNetworkReachabilityStatus networkStatus = (MHNetworkReachabilityStatus)status;
        networkStatus_ = networkStatus;
        !statusChangeBlock ? : statusChangeBlock(networkStatus);
    }];
    // 开始监控
    [mgr startMonitoring];
}







+ (MHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(MHUploadProgress)progress
                                 success:(MHResponseSuccess)success
                                 failure:(MHResponseFailure)failure
{
    if ([NSURL URLWithString:uploadingFile] == nil)
    {
        MHAppLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return nil;
    }
    
    NSURL *uploadURL = nil;
    if ([self baseUrl] == nil)
    {
        uploadURL = [NSURL URLWithString:url];
    } else
    {
        uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
    
    if (uploadURL == nil)
    {
        MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
        return nil;
    }
 
    
    AFHTTPSessionManager *manager = [self _manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
    MHURLSessionTask *session = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        // 回调+解析数据
        [self _successDataWithResponseObject:responseObject callback:success];
        
        [[self _allTasks] removeObject:session];
        
        
        if (error)
        {
            // 处理错误信息
            [self _handleCallbackWithError:error failure:failure];
            
            if ([self _isDebug])
            {
                [self _logWithFailureError:error url:response.URL.absoluteString params:nil];
            }
        } else {
            if ([self _isDebug])
            {
                [self _logWithSuccessResponseObject:responseObject
                                                url:response.URL.absoluteString
                                             params:nil];
            }
        }
    }];
    
    if (session) {
        [[self _allTasks] addObject:session];
    }
    
    return session;
}

+ (MHURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(MHUploadProgress)progress
                               success:(MHResponseSuccess)success
                               failure:(MHResponseFailure)failure
{
    if ([self baseUrl] == nil)
    {
        if ([NSURL URLWithString:url] == nil)
        {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else
    {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil)
        {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self _shouldAutoEncode])
    {
        url = [self _encodeUrl:url];
    }
    
    // 获取全路径
    NSString *absolute = [self _absoluteUrlWithPath:url];
    
    
    AFHTTPSessionManager *manager = [self _manager];
    MHURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //0.9 压缩量最好
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        
        NSString *imageFileName = filename;
        // fileName为空的情况
        if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 清除掉请求
        [[self _allTasks] removeObject:task];
        // 解析+回调
        [self _successDataWithResponseObject:responseObject callback:success];
        // 调试日志
        if ([self _isDebug])
        {
            [self _logWithSuccessResponseObject:responseObject
                                            url:absolute
                                         params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 清除掉请求
        [[self _allTasks] removeObject:task];
        
        // 处理错误信息
        [self _handleCallbackWithError:error failure:failure];
        
        if ([self _isDebug])
        {
            [self _logWithFailureError:error url:task.response.URL.absoluteString params:nil];
        }
    }];
    //???: 什么玩意   继续请求吗
    [session resume];
    
    if (session)
    {
        [[self _allTasks] addObject:session];
    }
    
    return session;
}

+ (MHURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(MHDownloadProgress)progressBlock
                               success:(MHResponseSuccess)success
                               failure:(MHResponseFailure)failure {
    if ([self baseUrl] == nil)
    {
        if ([NSURL URLWithString:url] == nil)
        {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            MHAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    AFHTTPSessionManager *manager = [self _manager];
    
    MHURLSessionTask *session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self _allTasks] removeObject:session];
        
        if (error == nil)
        {
            if (success) {
                success(filePath.absoluteString);
            }
            
            if ([self _isDebug]) {
                MHAppLog(@"Download success for url 【 %@ 】",
                          [self _absoluteUrlWithPath:url]);
            }
        } else {
            [self _handleCallbackWithError:error failure:failure];
            
            if ([self _isDebug]) {
                MHAppLog(@"Download fail for url :\n --> \n %@ \n <----\n, reason is : \n --> \n %@ \n <----\n",
                          [self _absoluteUrlWithPath:url],
                          [error description]);
            }
        }
 
    }];
    
    
    [session resume];
    if (session) {
        [[self _allTasks] addObject:session];
    }
    return session;
}

#pragma mark - Private  获取网络管理
+ (AFHTTPSessionManager *)_manager
{
    //@synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改。这个是objective-c的一个锁定令牌，防止self对象在同一时间内被其它线程访问，起到线程的保护作用。 一般在公用变量的时候使用，如单例模式或者操作类的static变量中使用。
    // 但是@synchronized 比较好性能
    @synchronized (self) {
        // 只要不切换baseurl，就一直使用同一个session manager
        if (sharedManager_ == nil  ||  isBaseURLChanged_) {
            
            // 开启转圈圈
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            
            
            AFHTTPSessionManager *manager = nil;;
            if ([self baseUrl] != nil) {

                manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
                
            } else
            {
                manager = [AFHTTPSessionManager manager];
            }
            
            // 配置请求格式
            switch (requestType_)
            {
                case kMHRequestTypeJSON:
                {
                    manager.requestSerializer = [AFJSONRequestSerializer serializer];
                    break;
                }
                case kMHRequestTypePlainText:
                {
                    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            
            // 配置响应格式
            switch (responseType_)
            {
                case kMHResponseTypeJSON:
                {
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    break;
                }
                case kMHResponseTypeXML:
                {
                    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                    break;
                }
                case kMHResponseTypeData:
                {
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    break;
                }
                default: {
                    break;
                }
            }
            // 默认是 NSUTF8StringEncoding
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            
            // 配置请求头
            for (NSString *key in httpHeaders_.allKeys)
            {
                if (httpHeaders_[key] != nil)
                {
                    [manager.requestSerializer setValue:httpHeaders_[key] forHTTPHeaderField:key];
                }
            }
            // 配置接受的格式  默认是 @"application/json", @"text/json", @"text/javascript"
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
            
            // 配置请求超时
            manager.requestSerializer.timeoutInterval = timeout_;
            
            // 设置允许同时最大并发数量，过大容易出问题
            manager.operationQueue.maxConcurrentOperationCount = 3;
            sharedManager_ = manager;
        }
        
 
        if (shouldObtainLocalWhenNetworkUnconnected_ && (cacheGetData_ || cachePostData_))
        {
            // 检测网络
            [self checkNetworkReachabilityStatusBlock:nil];
        }
        
        return sharedManager_;

    }
}



#pragma mark - 调试模式打开 调试打印
+ (void)_logWithSuccessResponseObject:(id)responseObject url:(NSString *)url params:(NSDictionary *)params
{
    MHAppLog(@"----------REQUEST SUCCESS FINISHED----------");
    MHAppLog(@"absoluteUrl:\n====\n %@ \n====\n",[self _generateGETAbsoluteURL:url params:params]);
    MHAppLog(@"     params:\n====\n %@ \n====\n",params);
    MHAppLog(@"       data:\n====\n %@ \n====\n",[self _tryToParseData:responseObject]);
    MHAppLog(@"----------REQUEST SUCCESS FINISHED----------");
}



+ (void)_logWithFailureError:(NSError *)error url:(NSString *)url params:(NSDictionary *)params
{
    MHAppLog(@"----------REQUEST FAILURE FINISHED----------");
    MHAppLog(@"absoluteUrl:\n====\n %@ \n====\n",[self _generateGETAbsoluteURL:url params:params]);
    MHAppLog(@"     params:\n====\n %@ \n====\n",params);
    MHAppLog(@" errorInfos:\n====\n %@ \n====\n",[error localizedDescription]);
    MHAppLog(@"----------REQUEST FAILURE FINISHED----------");
}

#pragma mark - 是否要回调错误信息
+ (void)_handleCallbackWithError:(NSError *)error failure:(MHResponseFailure)failure
{
    if ([error code] == NSURLErrorCancelled)
    {
        if (shouldCallbackOnCancelRequest_) !failure ? :failure(error);
    } else
    {
        !failure ? : failure(error);
    }
}
#pragma mark - 获取请求路径 ps: 仅对一级字典结构起作用
+ (NSString *)_generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params
{
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0)   return url;
    
    NSString *queries = @"";
    for (NSString *key in params)
    {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

#pragma mark - 获取缓存路径
static inline NSString *cachePath()
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MHNetworkingCaches"];
}


#pragma mark - 获取缓存数据
+ (id) _getCahceResponseObjectWithURL:(NSString *)url parameters:(NSDictionary *)params
{
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        NSString *absoluteURL = [self _generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString mh_networking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            MHAppLog(@"Read data from cache for url:\n====\n  %@  \n====\n", url);
        }
    }
    
    return cacheData;
}

#pragma mark - 缓存数据
+ (void) _cacheDataWithResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:(NSDictionary *)params
{
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]])
    {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:directoryPath isDirectory:nil])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                MHAppLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        // 获取全路径
        NSString *absoluteURL = [self _generateGETAbsoluteURL:request.URL.absoluteString params:params];
        // 加密
        NSString *key = [NSString mh_networking_md5:absoluteURL];
        // 拼接路劲
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        
        if ([dict isKindOfClass:[NSData class]])
        {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil)
        {
            BOOL isOk = [manager createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                MHAppLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                MHAppLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

#pragma mark - 获取全路径Url
+ (NSString *)_absoluteUrlWithPath:(NSString *)path
{
    if (path == nil || path.length == 0) return @"";
    
    if ([self baseUrl] == nil || [[self baseUrl] length] == 0) return path;

    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"])
    {
        if ([[self baseUrl] hasSuffix:@"/"])
        {
            if ([path hasPrefix:@"/"])
            {
                NSMutableString * mutablePath = [NSMutableString stringWithString:path];
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",
                               [self baseUrl], mutablePath];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            }
        } else {
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
            } else {
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                               [self baseUrl], path];
            }
        }
    }
    
    return absoluteUrl;
}

#pragma mark - 编码(private)
+ (NSString *)_encodeUrl:(NSString *)url
{
    return [self _URLEncode:url];
}


#pragma mark - 成功响应(private)
+ (void)_successDataWithResponseObject:(id)responseObject callback:(MHResponseSuccess)success
{
    if (success)
    {
        success([self _tryToParseData:responseObject]);
    }
}



#pragma mark - 解析json(private)
+ (id)_tryToParseData:(id)responseData
{
    if ([responseData isKindOfClass:[NSData class]])
    {
        // 尝试解析成JSON
        if (responseData == nil)
        {
            return responseData;
        } else
        {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];

            if (error != nil)
            {
                return responseData;
            } else {
                return response;
            }
        }
    } else
    {
        return responseData;
    }
}

#pragma mark - 将URL使用UTF8编码(private)
/**
 *  将URL使用UTF8编码，用于处理链接中有中文时无法请求的问题
 */
+ (NSString *)_URLEncode:(NSString *)url
{
    //UTF8 编码
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

@end

