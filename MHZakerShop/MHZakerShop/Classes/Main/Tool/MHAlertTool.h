//
//  MHAlertTool.h
//  MHZakerShop
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  系统alertViewController封装 左右两个按钮

#import <Foundation/Foundation.h>

@interface MHAlertTool : NSObject
/**
 *  系统alertViewController封装
 *  @param presentedController哪个控制器弹出这个控件
 *  @param title              标题
 *  @param message            详情
 *  @param leftButtonTitle    左边按钮的名称
 *  @param rightButtonTitle   右边按钮的名称
 *  @param leftButtonHandler  左边按钮的点击事件
 *  @param rightButtonHandler 右边按钮的点击事件
 */
+ (void)alertWithPresentedController:(UIViewController *)presentedController title:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonHandler:(void (^)())leftButtonHandler rightButtonHandler:(void(^)())rightButtonHandler;



@end
