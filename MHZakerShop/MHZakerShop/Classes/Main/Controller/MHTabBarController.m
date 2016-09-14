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
/** home */
@property (nonatomic , weak) MHHomeController *home ;

/** befefit */
@property (nonatomic , weak) MHBenefitController *benefit ;

/** shop */
@property (nonatomic , weak) MHShopController *shop ;

/** topic */
@property (nonatomic , weak) MHTopicController *topic ;
@end

@implementation MHTabBarController

- (void)dealloc
{
    MHDealloc;
}


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
    
    // 添加通知中心
    [self _addNotificationCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 添加通知中心
- (void) _addNotificationCenter
{
    // 主页滚动视图数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveHomeBannersData:) name:MHHomeBannersDataDidLoad object:nil];
    
    // 主页数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveHomeBlocksData:) name:MHHomeBlocksDataDidLoad object:nil];
    
    // 福利数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveBenefitBlocksData:) name:MHBenefitBlocksDataDidLoad object:nil];
    
    // 好店 滚动视图 数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveShopBannersData:) name:MHShopBannersDataDidLoad object:nil];
    
    // 好店数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveShopBlocksData:) name:MHShopBlocksDataDidLoad object:nil];
    
    // 专题数据
    [MHNotificationCenter addObserver:self selector:@selector(_receiveTopicBlocksData:) name:MHTopicBlocksDataDidLoad object:nil];
}

#pragma mark - 通知事件
- (void)_receiveHomeBannersData:(NSNotification *)note
{
    MHLogFunc;
}

- (void)_receiveHomeBlocksData:(NSNotification *)note
{
    MHLogFunc;
}

- (void)_receiveBenefitBlocksData:(NSNotification *)note
{
    MHLogFunc;
}

- (void)_receiveShopBannersData:(NSNotification *)note
{
    MHLogFunc;
}

- (void)_receiveShopBlocksData:(NSNotification *)note
{
    MHLogFunc;
}

- (void)_receiveTopicBlocksData:(NSNotification *)note
{
    MHLogFunc;
}

#pragma mark - 添加所有的子控制器
- (void) _setupAllChildControllers
{
    // 主页
    MHHomeController *home = [[MHHomeController alloc] init];
    self.home = home;
    [self _addChildControllerWithController:home title:@"主页"];
    
    // 福利
    MHBenefitController *benefit = [[MHBenefitController alloc] init];
    self.benefit = benefit;
    [self _addChildControllerWithController:benefit title:@"福利"];
    
    // 好店
    MHShopController *shop = [[MHShopController alloc] init];
    self.shop = shop;
    [self _addChildControllerWithController:shop title:@"好店"];
    
    // 专题
    MHTopicController *topic = [[MHTopicController alloc] init];
    self.topic = topic;
    [self _addChildControllerWithController:topic title:@"专题"];
    
}

#pragma mark - 添加tabbar
- (void) _setupTabBar
{
    //!!!: 这里强制修改 tabBar的高度为44  看起来比较和谐
    self.tabBar.mh_height = 40;
    self.tabBar.mh_y = MHMainScreenHeight - self.tabBar.mh_height ;
    
    
    // 添加自定义的tabbar
    MHTabBar *myTabBar = [[MHTabBar alloc] init];
    myTabBar.delegate = self;
    myTabBar.frame = self.tabBar.bounds;
    
    
    [self.tabBar addSubview:myTabBar];
    
}

#pragma mark - 添加一个控制器
- (void) _addChildControllerWithController:(MHViewController *)controller title:(NSString *)title
{
    // 设置主题 去掉title
//    controller.title = title;
    
    // FIXME: 为什么这里设置为NO 但是父控制器还是YES Why？
    // 原因是 执行顺序的问题 由于控制器是懒加载 你在这里操作显然不对
    // controller禁止掉向下swipe就dimiss控制器的手势
//    controller.dismissEnabled = NO;
    
    // 添加为tabbar控制器的子控制器
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];

}






#pragma mark - MHTabBarDelegate
- (void)tabBar:(MHTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to{
    // 选中的按钮
    self.selectedIndex = to;
}

- (void)tabBarDidClickedSettingButton:(MHTabBar *)tabBar
{

    MHSettingController *setting = [[MHSettingController alloc] init];
    MHNavigationController *nav = [[MHNavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
@end
