//
//  MHBanner.h
//  MHZakerShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  主页和好店的 banner视图的模型数据

#import <Foundation/Foundation.h>

@interface MHBanner : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 点击的接口 可能是web_url 和 api_url */
@property (nonatomic, copy) NSString *url;

/** 大图片地址 */
@property (nonatomic, copy) NSString *pic;

/** 小图片地址 */
@property (nonatomic, copy) NSString *s_pic;

/** 商品id */
@property (nonatomic, copy) NSString *pk;

//链接类型（web/api）
@property (nonatomic, assign) MHGoodsUrlType type;
@end
