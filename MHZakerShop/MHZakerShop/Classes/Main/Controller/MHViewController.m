//
//  MHViewController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  设置背景颜色+向下滑动dismiss控制器

//FIXME: 父控制器的方法 必须加上唯一前缀mh 否则子类同名的方法 会覆盖掉父类的方法 结果就会有不知名的bug出现  切起

#import "MHViewController.h"

@interface MHViewController () <UIGestureRecognizerDelegate>

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // 初始化
    [self _mh_setup];
    
    // 添加一个手势
    [self _mh_setupGestureRecognizer];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)_mh_setup
{
    // 背景颜色
    self.view.backgroundColor = MHGlobalViewBackgroundColor;
    
    // 允许轻扫dismiss控制器
    _dismissEnabled = YES;
}


#pragma mark - 添加手势
- (void) _mh_setupGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_mh_swipe:)];
    swipeGr.direction = UISwipeGestureRecognizerDirectionDown;
    swipeGr.delegate = self;
    [self.view addGestureRecognizer:swipeGr];
}

- (void)_mh_swipe:(UISwipeGestureRecognizer *)swipeGr
{
    // 判断是 present还是push
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1)
    {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self)
        {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
            
            MHLog(@"%@ _swipe pop", [self class] );
        }
    }
    else
    {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
        
        MHLog(@"%@ _swipe  dismiss", [self class] );
    }
    
}



 #pragma mark - UIGestureRecognizerDelegate
 - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.isDismissEnabled;
}


@end
