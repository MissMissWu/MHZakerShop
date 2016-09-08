//
//  MHBottomToolBarController.h
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  这个基类  主要是 后退x按钮在下面的 bottomToolBar  的界面需要

#import "MHViewController.h"
@class MHBottomToolBar;
@interface MHBottomToolBarController : MHViewController

/** 底部操作条 */
@property (nonatomic , weak) MHBottomToolBar *bottomToolBar ;
@end
