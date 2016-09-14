//
//  MHSettingController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

// FIXME: 自己添加了 清除缓存+反馈/建议+关于我们 按钮的normal和highlight的背景图片
// zaker自带的点击效果太差了

//!!!:self.presentedViewController , self.presentingViewController 区别
/**
 presentedViewController和presentingViewController，他们分别是被present的控制器和正在presenting的控制器。
 比如说:
 控制器A和B，[A presentViewController B animated：YES completion：nil]; 那么A相对于B就是presentingViewController，B相对于A是presentedViewController.
 即这个时候
 　　　　B.presentingViewController = A;
 　　　　A.presentedViewController = B;
 */

#import "MHSettingController.h"
#import "MHAboutUsController.h"
#import "MHFeedbackController.h"
#import "MHAlertTool.h"
@interface MHSettingController ()
@property (weak, nonatomic) IBOutlet UIButton *clearCacheBtn;

@end

@implementation MHSettingController

- (void)dealloc
{
    MHDealloc;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = MHGlobalDeepPinkColor;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 设置导航栏控制器
    [self _setupNavigationItem];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    
}

#pragma mark - 初始化
- (void)_setup
{
    
}

#pragma mark - 设置导航栏
- (void)_setupNavigationItem
{
    UIBarButtonItem *logoItem = [UIBarButtonItem mh_itemWithImageName:@"LOGO_white" highImageName:@"LOGO_white" target:nil action:nil];
    UIBarButtonItem *leftNegativeSpacerItem = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    leftNegativeSpacerItem.width = -15;
    self.navigationItem.leftBarButtonItems = @[leftNegativeSpacerItem,logoItem];
    

    UIBarButtonItem *sortItem = [UIBarButtonItem mh_itemWithImageName:@"white_close_btn" target:self action:@selector(_close)];
    UIBarButtonItem *rightNegativeSpacerItem = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    rightNegativeSpacerItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacerItem,sortItem];
}

- (void)_close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//FIXME: xib拖出来的按钮 这里有一个按钮高亮显示文字出错的问题 高亮选中普通状况下 高亮显示的文字不对  其他状态下 高亮显示正确
// 解决办法自定义一个Button 重写setHighlighted覆盖掉父类的操作

#pragma mark - 按钮点击事件
// 绑定
- (IBAction)_bind:(UIButton *)sender
{
    MHLogFunc;
    MHBindType type = sender.tag;
    switch (type) {
        case MHBindTypeSinaWeibo:
            MHLog(@"绑定新浪微博");
            break;
        case MHBindTypeTaoBao:
            MHLog(@"绑定淘宝帐号");
            break;
        default:
            break;
    }
    
    
    if (sender.isSelected)
    {
        
        [MHAlertTool alertWithPresentedController:self title:nil message:@"确定要解除绑定吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定" leftButtonHandler:nil rightButtonHandler:^{
            // 确定
            sender.selected = NO;
            sender.backgroundColor = MHGlobalPinkColor;
        }];
        
    }else{
        
        sender.selected = YES;
        sender.backgroundColor = [UIColor blackColor];
        
    }
    
    
    
    
}
// 切换主题
- (IBAction)_changTheme:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    sender.backgroundColor = sender.isSelected?[UIColor blackColor]:MHGlobalPinkColor;
    
    
}
// 清除缓存
- (IBAction)_clearCache {
    
    //???:  由于这里大多数是图片缓存，而我们又采用的是SDWebImage来异步缓存的图片，故这里清理缓存 应该是清理SDWebImage的缓存
    self.clearCacheBtn.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf =  self;
    [MHAlertTool alertWithPresentedController:self title:nil message:@"确定要清除所有缓存文件吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定" leftButtonHandler:nil rightButtonHandler:^{
       
        // 清理SDWebImage的缓存
        [MHWebImageTool clearWebImageCache];
        
       
        //提示
        [weakSelf _showClearAllCacheSuccess];
        
        
    }];
    

}

// 反馈/建议
- (IBAction)_feedback {
    
    MHFeedbackController *feedBack  =[[MHFeedbackController alloc] init];
    [self presentViewController:feedBack animated:YES completion:nil];
}

// 关于我们
- (IBAction)_aboutUs {
    
    MHAboutUsController *aboutUs  =[[MHAboutUsController alloc] init];
    [self presentViewController:aboutUs animated:YES completion:nil];
}



/**
 *  提示清除缓存
 */
- (void)_showClearAllCacheSuccess
{

    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    
    // 2.显示文字
    label.text = @"成功清除所有缓存文件。";
    
    
    // 3.设置背景
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_bg"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = MHMediumFont(14.0f);
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;
    
    // 4.设置frame
    label.mh_x = 30;
    label.mh_width = MHMainScreenWidth - 2 * label.mh_x;
    label.mh_height = 30;
    label.mh_y = MHMainScreenHeight;
    
    // 5.添加到导航控制器的view
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 6.动画
    CGFloat duration = 0.1;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // 往上移动一个
        label.transform = CGAffineTransformMakeTranslation(0, -78.0f);
    } completion:^(BOOL finished) { // 向下移动完毕
        
        // 延迟delay秒后，再执行动画
        CGFloat delay = 2.0;
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
            
            self.clearCacheBtn.userInteractionEnabled = YES;
        }];
    }];
}

@end
