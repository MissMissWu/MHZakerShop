//
//  MHHttpTool.h
//  MHNetworking
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworkReachabilityManager.h"
/**
 *  网络提示 -- 失去连接  发请求那里
 */
UIKIT_EXTERN NSString * const MHDidNotHaveNetworkAlertMessage ;
/**
 *  连接服务器失败
 */
UIKIT_EXTERN NSString * const MHDidUnConnectWebServiceAlertMessage ;

/**
 *  网络提示 --当网络突然失去连接
 */
UIKIT_EXTERN NSString * const MHDidUnConnectNetworkAlertMessage ;





/*!
 *  @author Mike,
 *
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 */
typedef void (^MHDownloadProgress)(int64_t bytesRead,
                                    int64_t totalBytesRead);

typedef MHDownloadProgress MHGetProgress;
typedef MHDownloadProgress MHPostProgress;

/*!
 *  @author Mike,
 *
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^MHUploadProgress)(int64_t bytesWritten,
                                  int64_t totalBytesWritten);

typedef NS_ENUM(NSUInteger, MHResponseType) {
    kMHResponseTypeJSON = 1, // 默认
    kMHResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    kMHResponseTypeData = 3
};

typedef NS_ENUM(NSUInteger, MHRequestType) {
    kMHRequestTypeJSON = 1, // 默认
    kMHRequestTypePlainText  = 2 // 普通text/html
};


typedef NS_ENUM(NSInteger, MHNetworkReachabilityStatus) {
    MHNetworkReachabilityStatusUnknown          = -1, //未知网络
    MHNetworkReachabilityStatusNotReachable     = 0,  //网络无连接
    MHNetworkReachabilityStatusReachableViaWWAN = 1,  //2，3，4G网络
    MHNetworkReachabilityStatusReachableViaWiFi = 2,  //WIFI网络
};


/**
 *  检测网络的block
 */
typedef void(^MHNetworkingReachabilityStatus)(MHNetworkReachabilityStatus status);




@class NSURLSessionTask;

// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask MHURLSessionTask;

/*!
 *  @author Mike,
 *
 *  请求成功的回调
 *
 *  @param response 服务端返回的数据类型，通常是字典
 */
typedef void(^MHResponseSuccess)(id responseObject);

/*!
 *  @author Mike,
 *
 *  网络响应失败时的回调
 *
 *  @param error 错误信息
 */
typedef void(^MHResponseFailure)(NSError *error);

/*!
 *
 *  基于AFNetworking的网络层封装类.
 *
 *  @note 这里只提供公共api
 */
@interface MHHttpTool : NSObject

/*!
 *  用于指定网络请求接口的基础url，如：
 *  http://henishuo.com或者http://101.200.209.244
 *  通常在AppDelegate中启动时就设置一次就可以了。如果接口有来源
 *  于多个服务器，可以调用更新
 *  @param baseUrl 网络接口的基础url
 */
+ (void)updateRequestBaseUrl:(NSString *)baseUrl;
/*!
 *  对外公开可获取当前所设置的网络接口基础url
 *
 *  @return 当前基础url
 */
+ (NSString *)baseUrl;



/**
 *	清除缓存
 */
+ (void)clearCaches;
/**
 *	获取缓存总大小/bytes
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;
/**
 *	默认不会自动清除缓存，如果需要，可以设置自动清除缓存，并且需要指定上限。当指定上限>0M时，
 *  若缓存达到了上限值，则每次启动应用则尝试自动去清理缓存。
 *
 *	@param mSize				缓存上限大小，单位为M（兆），默认为0，表示不清理
 */
+ (void)autoClearCacheWithLimitSize:(NSUInteger)limitSize;
/**
 *	默认只缓存GET请求的数据，对于POST请求是不缓存的。如果要缓存POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *	@param isCacheGet			默认为 NO
 *	@param isCachePost	        默认为 NO
 */
+ (void)cacheGetRequestData:(BOOL)isCacheGet shouldCachePostData:(BOOL)isCachePost;
/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *	@param shouldObtain	YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;





/*!
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;




/**
 *	设置请求超时时间，默认为60秒
 *
 *	@param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;




/*!
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType 请求格式，默认为JSON
 *  @param responseType 响应格式，默认为JSON，
 *  @param shouldAutoEncode YES or NO,默认为NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(MHRequestType)requestType
             responseType:(MHResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;


/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;




/**
 *	取消所有请求
 */
+ (void)cancelAllRequest;
/**
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的MHURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;











/*!
 *  @author Mike
 *
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList?categoryid=1
 *  @param success 接口成功请求到数据的回调
 *  @param failure 接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(MHResponseSuccess)success
                         failure:(MHResponseFailure)failure;
/*!
 *  @author Mike
 *
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需要的拼接参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param failure 接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(MHResponseSuccess)success
                             failure:(MHResponseFailure)failure;

+ (MHURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(MHGetProgress)progress
                          success:(MHResponseSuccess)success
                          failure:(MHResponseFailure)failure;

/*!
 *  @author Mike
 *
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param success 接口成功请求到数据的回调
 *  @param failure 接口请求数据失败的回调
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (MHURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                           success:(MHResponseSuccess)success
                           failure:(MHResponseFailure)failure;

+ (MHURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                          progress:(MHPostProgress)progress
                           success:(MHResponseSuccess)success
                           failure:(MHResponseFailure)failure;














/**
 *	@author Mike
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image		图片对象
 *	@param url			上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name		    与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *	@param success		上传成功回调
 *	@param failure		上传失败回调
 *
 *	@return
 */
+ (MHURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(MHUploadProgress)progress
                               success:(MHResponseSuccess)success
                               failure:(MHResponseFailure)failure;

/**
 *	@author Mike
 *
 *	上传文件操作
 *
 *	@param url			    上传路径
 *	@param uploadingFile	待上传文件的路径
 *	@param progress			上传进度
 *	@param success			上传成功回调
 *	@param failure			上传失败回调
 *
 *	@return
 */
+ (MHURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(MHUploadProgress)progress
                                 success:(MHResponseSuccess)success
                                 failure:(MHResponseFailure)failure;


/*!
 *  @author Mike
 *
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param success       下载成功后的回调
 *  @param failure       下载失败后的回调
 */
+ (MHURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(MHDownloadProgress)progressBlock
                               success:(MHResponseSuccess)success
                               failure:(MHResponseFailure)failure;









/**
 *  检测网络状况
 */
+ (void) checkNetworkReachabilityStatusBlock:(MHNetworkingReachabilityStatus)statusChangeBlock;








@end
