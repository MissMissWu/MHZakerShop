//
//  UIFont+MHExtension.h
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//
/**
 *  Mike_He
 *  这个分类主要用来 字体...
 (
 "PingFangSC-Ultralight",
 "PingFangSC-Regular",
 "PingFangSC-Semibold",
 "PingFangSC-Thin",
 "PingFangSC-Light",
 "PingFangSC-Medium"
 )
 
 
 */


/**设置系统的字体大小（YES：粗体 NO：常规）*/
#define MHFont(__size__,__bold__) ((__bold__)?([UIFont boldSystemFontOfSize:__size__]):([UIFont systemFontOfSize:__size__]))







/** 极细体 */
#define MHPingFangSC_UltralightFont(__size__) [UIFont mh_fontForPingFangSC_UltralightFontOfSize:__size__]
/** 常规体 */
#define MHPingFangSC_RegularFont(__size__)    [UIFont mh_fontForPingFangSC_RegularFontOfSize:__size__]
/** 中粗体 */
#define MHPingFangSC_SemiboldFont(__size__)   [UIFont mh_fontForPingFangSC_SemiboldFontOfSize:__size__]
/** 纤细体 */
#define MHPingFangSC_ThinFont(__size__)       [UIFont mh_fontForPingFangSC_ThinFontOfSize:__size__]
/** 细体 */
#define MHPingFangSC_LightFont(__size__)      [UIFont mh_fontForPingFangSC_LightFontOfSize:__size__]
/** 中黑体 */
#define MHPingFangSC_MediumFont(__size__)     [UIFont mh_fontForPingFangSC_MediumFontOfSize:__size__]


// 该项目 主要使用以下三种字体
// 中等
#define MHMediumFont(__size__)     [UIFont mh_fontForPingFangSC_MediumFontOfSize:__size__]

// 常规
#define MHRegularFont(__size__)    [UIFont mh_fontForPingFangSC_RegularFontOfSize:__size__]



#import <UIKit/UIKit.h>

@interface UIFont (MHExtension)

/**
 *  苹方极细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_UltralightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方常规体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_RegularFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中粗体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_SemiboldFontOfSize:(CGFloat)fontSize;

/**
 *  苹方纤细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_ThinFontOfSize:(CGFloat)fontSize;

/**
 *  苹方细体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_LightFontOfSize:(CGFloat)fontSize;

/**
 *  苹方中黑体
 *
 *  @param fontSize 字体大小
 *
 */
+(instancetype) mh_fontForPingFangSC_MediumFontOfSize:(CGFloat)fontSize;




@end
