//
//  UIBarButtonItem+MHExtension.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIBarButtonItem+MHExtension.h"

@implementation UIBarButtonItem (MHExtension)


+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    
    if(imageName) [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    

    if(highImageName) [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    //!!!: Mike_He 不这样写 会报   expression is not assignable 解决方法
    CGRect frame = button.frame;
    frame.size  = button.currentBackgroundImage.size;
    button.frame = frame;
    
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)mh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [UIBarButtonItem mh_itemWithImageName:imageName highImageName:nil target:target action:action];
}
@end
