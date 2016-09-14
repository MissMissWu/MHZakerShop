//
//  MHViewController.h
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  所有控制器的 父类

#import <UIKit/UIKit.h>

@interface MHViewController : UIViewController


/** 是否支持向下轻扫 dismiss控制器 默认YES */
@property (nonatomic , assign , getter=isDismissEnabled) BOOL dismissEnabled;


@end
