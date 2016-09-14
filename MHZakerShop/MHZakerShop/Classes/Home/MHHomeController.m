//
//  MHHomeController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHHomeController.h"
#import "MHCycleScrollView.h"


@interface MHHomeController ()

@end

@implementation MHHomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化
    [self _setup];
    
    // 初始化子控件
    [self _setupSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public 
- (void)reloadBannersData
{
    
}

- (void)reloadBlocksData
{
    
}

#pragma mark - 初始化
- (void)_setup
{
    self.dismissEnabled = NO;
}

#pragma mark - 初始化子控件
- (void)_setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MHMainScreenWidth, MHMainScreenHeight)];
    scrollView.backgroundColor = MHGlobalViewBackgroundColor;
    [self.view addSubview:scrollView];
}

@end
