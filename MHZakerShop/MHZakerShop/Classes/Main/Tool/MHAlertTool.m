//
//  MHAlertTool.m
//  MHZakerShop
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHAlertTool.h"

@implementation MHAlertTool


+ (void)alertWithPresentedController:(UIViewController *)presentedController title:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftButtonHandler:(void (^)())leftButtonHandler rightButtonHandler:(void(^)())rightButtonHandler
{
    //需要提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    if(leftButtonTitle)
    {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:leftButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            !leftButtonHandler?:leftButtonHandler();
            
        }];
        
        [alertController addAction:cancelAction];
    }
    if(rightButtonTitle){
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:rightButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            !rightButtonHandler?:rightButtonHandler();
            
        }];

        [alertController addAction:confirmAction];
    }
    
    
    [presentedController presentViewController:alertController animated:YES completion:nil];
}
@end
