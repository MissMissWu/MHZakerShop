//
//  MHTabBar.h
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MHTabBar;

@protocol MHTabBarDelegate <NSObject>

@optional
- (void) tabBar:(MHTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;

// 设置按钮被点击了
- (void)tabBarDidClickedSettingButton:(MHTabBar *)tabBar;

@end

@interface MHTabBar : UIView


@property (nonatomic, weak) id<MHTabBarDelegate> delegate;



@end
