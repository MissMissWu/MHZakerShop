//
//  MHCommon.h
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 苹方字体分类
#import "UIFont+MHExtension.h"

// 颜色分类
#import "Colours.h"

// 根据颜色生成图片
#import "UIImage+ImageWithColor.h"

// image分类
#import "UIImage+MH.h"

// UIBarButtonItem分类
#import "UIBarButtonItem+MHExtension.h"

// UIView的分类
#import "UIView+MH.h"

// 异步下载网络图片
#import "MHWebImageTool.h"

/** 绑定 */
typedef NS_ENUM(NSUInteger, MHBindType) {
    MHBindTypeNone      = 10, // 无
    MHBindTypeSinaWeibo = 11, // 绑定新浪微博
    MHBindTypeTaoBao  = 12, // 绑定支付宝
};

/** wepView翻页 */
typedef NS_ENUM(NSUInteger, MHWebViewPageType) {
    MHWebViewPageTypeNone = 15, // 无翻页
    MHWebViewPageTypeNext = 16, // 下一页,
    MHWebViewPageTypePre = 17, //  上一页,
};

/**商品Ulr是web_url 还是api_url */
typedef NS_ENUM(NSUInteger, MHGoodsUrlType) {
    MHGoodsUrlTypeNone = 20,
    MHGoodsUrlTypeApi = 21, //api_url
    MHGoodsUrlTypeWeb = 22, //web_url
};

/** 请求Url */
UIKIT_EXTERN NSString  * const MHAllDataUrl;

/** 主页banner滚动视图数据加载完毕 */
UIKIT_EXTERN NSString * const MHHomeBannersDataDidLoad ;

/** 好店banner滚动视图数据加载完毕 */
UIKIT_EXTERN NSString * const MHShopBannersDataDidLoad ;



/** 主页blockData数据加载完毕 */
UIKIT_EXTERN NSString * const MHHomeBlocksDataDidLoad   ;

/** 好店blockData数据加载完毕 */
UIKIT_EXTERN NSString * const MHShopBlocksDataDidLoad   ;

/** 福利blockData数据加载完毕 */
UIKIT_EXTERN NSString * const MHBenefitBlocksDataDidLoad;

/** 好店blockData数据加载完毕 */
UIKIT_EXTERN NSString * const MHTopicBlocksDataDidLoad  ;

// 常量


/**
 *  通知中心
 */
#define MHNotificationCenter [NSNotificationCenter defaultCenter]

/**
 * 设置颜色
 */
#define MHColorFromHexString(__hexString__) [UIColor colorFromHexString:__hexString__]



// 颜色

// 全局粉色
#define MHGlobalPinkColor [UIColor colorFromHexString:@"#ff5b8d"]

// 全局深粉色
#define MHGlobalDeepPinkColor [UIColor colorFromHexString:@"#f1446b"]


// 全局界面背景色
#define MHGlobalViewBackgroundColor [UIColor whiteColor]

/**
 *  全局白色字体
 */
#define MHGlobalWhiteTextColor      [UIColor colorFromHexString:@"#ffffff"]

/**
 *  全局灰色色字体颜色 + placeHolder字体颜色
 */
#define MHGlobalGrayTextColor       [UIColor colorFromHexString:@"#999999"]

/**
 *  全局黑色字体
 */
#define MHGlobalBlackTextColor      [UIColor colorFromHexString:@"#222222"]

/**
 *  全局灰色 背景
 */
#define MHGlobalGrayBackgroundColor [UIColor colorFromHexString:@"#f8f8f8"]

/**
 *  全局细下滑线颜色 以及分割线颜色
 */
#define MHGlobalBottomLineColor     [UIColor colorFromHexString:@"#e5e5e5"]

/**
 *  全局文字或者背景淡蓝色
 */
#define MHGlobalShadowBlueColor     [UIColor colorFromHexString:@"#98ddf8"]
/**
 *  全局文字或者背景深蓝色
 */
#define MHGlobalDeepBlueColor       [UIColor colorFromHexString:@"#32bbf2"]


// 浮点数常量


// 字体大小