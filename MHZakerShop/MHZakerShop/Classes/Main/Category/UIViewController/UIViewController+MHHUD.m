//
//  UIViewController+MHHUD.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIViewController+MHHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

static const void *MBProgressHUDKey = &MBProgressHUDKey;
@implementation UIViewController (MHHUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, MBProgressHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, MBProgressHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mh_showHudInView:(UIView *)view hint:(NSString *)hint
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = hint;
    hud.opacity = 0.45;
    [view addSubview:hud];
    [hud show:YES];
    [self setHUD:hud];
}

- (void)mh_showHint:(NSString *)hint
{
    //先hide掉之前的hud
    [self mh_hideHud];
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.opacity = 0.45;
    hud.margin = 10.f;
    hud.yOffset = -(view.frame.size.height*0.5-64-64*0.5);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

- (void)mh_showHint:(NSString *)hint yOffset:(float)yOffset {
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.opacity = 0.45;
    hud.margin = 10.f;
    hud.yOffset = -(view.frame.size.height*0.5-64-64*0.5);
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0f];
}

- (void)mh_hideHud
{
    [[self HUD] hide:YES];
}


@end
