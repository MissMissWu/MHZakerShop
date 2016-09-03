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