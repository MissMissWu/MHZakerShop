//
//  MHBottomToolBarController.m
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHBottomToolBarController.h"
#import "MHBottomToolBar.h"

@interface MHBottomToolBarController ()<MHBottomToolBarDelegate>



@end

@implementation MHBottomToolBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置subViews
    [self _mh_setupBottomToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 设置底部bottomToolbar
- (void)_mh_setupBottomToolBar
{
    CGFloat bottomToolBarH = 44.0f;
    MHBottomToolBar *bottomToolBar = [MHBottomToolBar bottomToolBar];
    bottomToolBar.frame = CGRectMake(0, MHMainScreenHeight - bottomToolBarH, MHMainScreenWidth, bottomToolBarH);
    bottomToolBar.delegate = self;
    self.bottomToolBar = bottomToolBar;
    [self.view addSubview:bottomToolBar];

    
    //FIXME: 这里遇到一个 特别 奇怪的bug  就是 MHBottomToolBar通过xib创建 在模拟器上可以显示，但是在真机上怎么也不显示？ Why?
    // reason:由于创建xib :cmd+N --> user Interface -->view 导致的
    // 解决办法 :
    // 正确创建: cmd+N --> user Interface --> empty --> 与View同名的xib -- 选中view --->class ：与view的名称相同
}


#pragma mark - MHBottomToolBarDelegate
- (void) bottomToolBarDidClickedCloseButton:(MHBottomToolBar *)bottomToolBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
