//
//  MHBlockData.h
//  MHZakerShop
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHBlockData : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 点击的接口 可能是web_url 和 api_url */
@property (nonatomic, copy) NSString *url;

/** 图片地址 */
@property (nonatomic, copy) NSString *default_pic;

/** 商品id */
@property (nonatomic, copy) NSString *pk;

/** 数据类型 */
@property (nonatomic, copy) NSString *data_type;


@end
