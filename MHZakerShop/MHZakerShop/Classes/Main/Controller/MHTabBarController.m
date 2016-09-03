//
//  MHTabBarController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHTabBarController.h"
#import "MHTabBar.h"
#import "MHHomeController.h"
#import "MHBenefitController.h"
#import "MHShopController.h"
#import "MHTopicController.h"
#import "MHSettingController.h"
#import "MHNavigationController.h"

@interface MHTabBarController () <MHTabBarDelegate>

@end

@implementation MHTabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        for (UIView *subView in self.tabBar.subviews) {
            
            if ([subView isKindOfClass:[MHTabBar class]]) continue;
            
            [subView removeFromSuperview];
        }
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 自定义tabbar 将自定义的tabBar天骄到系统的tabBar上
    
    // 添加所有的子控制器
    [self _setupAllChildControllers];
    
    // 添加tabbar
    [self _setupTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 添加所有的子控制器
- (void) _setupAllChildControllers
{
    // 主页
    [self _addChildControllerWithController:[[MHHomeController alloc] init] title:@"主页"];
    
    // 福利
    [self _addChildControllerWithController:[[MHBenefitController alloc] init] title:@"福利"];
    
    // 好店
    [self _addChildControllerWithController:[[MHShopController alloc] init] title:@"好店"];
    
    // 专题
    [self _addChildControllerWithController:[[MHTopicController alloc] init] title:@"专题"];
    
}

#pragma mark - 添加tabbar
- (void) _setupTabBar
{
    
    // 添加自定义的tabbar
    MHTabBar *myTabBar = [[MHTabBar alloc] init];
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:myTabBar];
    
}

#pragma mark - 添加一个控制器
- (void) _addChildControllerWithController:(UIViewController *)controller title:(NSString *)title
{
    // 设置主题
    controller.title = title;
    // 添加为tabbar控制器的子控制器
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:nav];

}

#pragma mark - MHTabBarDelegate
- (void)tabBar:(MHTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}

- (void)tabBarDidClickedSettingButton:(MHTabBar *)tabBar
{
    MHLogFunc;
}
@end
