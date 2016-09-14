//
//  MHTopToolBarController.m
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHTopToolBarController.h"

@interface MHTopToolBarController ()

@end

@implementation MHTopToolBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化基本框架
    //!!!: 加上前缀 以免 被子类莫名的覆盖掉了
    [self _mh_setupNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 设置导航栏
- (void)_mh_setupNavigationItem
{

    UIBarButtonItem *logoItem = [UIBarButtonItem mh_itemWithImageName:@"LOGO_transparent" highImageName:@"LOGO_transparent" target:nil action:nil];
    UIBarButtonItem *leftNegativeSpacerItem = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    leftNegativeSpacerItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[leftNegativeSpacerItem,logoItem];
    
    
    
    UIBarButtonItem *sortItem = [UIBarButtonItem mh_itemWithImageName:@"page_red_sort" target:self action:@selector(_mh_sort)];
    UIBarButtonItem *rightNegativeSpacerItem = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    rightNegativeSpacerItem.width = -20;
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacerItem,sortItem];
    
    //!!!: 以下方法这么设置  导致设置的图片屏幕两侧较远 故后面采用的是 customView
    
    // 参考链接
    //http://blog.csdn.net/woaifen3344/article/details/24793087
    //http://www.jianshu.com/p/5c74dfc94deb
    /**
    // 左侧栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"LOGO_transparent"] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // 右侧栏
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"page_red_sort"] style:UIBarButtonItemStylePlain target:self action:@selector(_sort)];
     **/
}


- (void)_mh_sort
{
    MHLogFunc;

}

@end
