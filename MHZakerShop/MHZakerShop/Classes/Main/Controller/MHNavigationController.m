//
//  MHNavigationController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHNavigationController.h"

@interface MHNavigationController ()
/**
 * 导航栏分隔线
 */
@property (nonatomic , weak) UIImageView * navSystemLine;

@end

@implementation MHNavigationController

+ (void)initialize
{
    // 设置UINavigationBarTheme的主题
    [self _setupNavigationBarTheme];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏的分割线
    [self _setupNavigationBarBottomLine];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void) _setup
{
    // 渲染导航栏的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

// 查询最后一条数据
- (UIImageView *)_findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self _findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - 设置导航栏的分割线
- (void)_setupNavigationBarBottomLine
{
    //!!!:这里之前设置系统的 navigationBarBottomLine.image = xxx;无效 Why？ 隐藏了系统的 自己添加了一个分割线
    
    // 隐藏系统的导航栏分割线
    UIImageView *navigationBarBottomLine = [self _findHairlineImageViewUnder:self.navigationBar];
    navigationBarBottomLine.hidden = YES;
    
    // 添加自己的分割线
    CGFloat navSystemLineH = 1.2f;
    UIImageView *navSystemLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.mh_height - navSystemLineH, MHMainScreenWidth, navSystemLineH)];
    navSystemLine.image = [UIImage mh_imageAlwaysShowOriginalImageWithImageName:@"shadow_small_top"];
    [self.navigationBar addSubview:navSystemLine];
    
    self.navSystemLine = navSystemLine;
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void) _setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];

    //!!!: 必须设置为透明  不然布局有问题 ios8以下  会崩溃/ 如果iOS8以下  请再_setup里面 设置透明 self.navigationBar.translucent = YES;
    [appearance setTranslucent:YES];
    
    // 设置导航栏的样式
    [appearance setBarStyle:UIBarStyleDefault];
    
    //设置导航栏的渲染色
    [appearance setTintColor:[UIColor whiteColor]];
    
    // 设置导航栏的背景色
    [appearance setBarTintColor:[UIColor whiteColor]];
    
}
@end
