//
//  MHDataBaseTool.h
//  MHZakerShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  Zaker数据库

#import <Foundation/Foundation.h>
#import "MHSingleton.h"
@interface MHDataBaseTool : NSObject

MHSingletonH(DataBase)
/**
 *  请求数据
 */
- (void) requestAllData;

/**
 * 得到主页滚动图片的数据
 */
- (NSArray *)homeBannersData;

/**
 * 得到好店滚动图片的数据
 */
- (NSArray *)shopBannersData;



/**
 * 得到主页block的数据
 */
- (NSArray *)homeBlocksData;

/**
 * 得到福利block的数据
 */
- (NSArray *)benefitBlocksData;

/**
 * 得到好店block的数据
 */
- (NSArray *)shopBlocksData;

/**
 * 得到专题block的数据
 */
- (NSArray *)topicBlocksData;
@end
