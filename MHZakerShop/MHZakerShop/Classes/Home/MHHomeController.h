//
//  MHHomeController.h
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  主页

#import "MHTopToolBarController.h"

@interface MHHomeController : MHTopToolBarController
/**
 *  刷新主页数据
 */
- (void)reloadBlocksData;


/**
 *  刷新主页banner
 */
- (void)reloadBannersData;
@end
