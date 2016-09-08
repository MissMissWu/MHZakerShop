//
//  MHTabBar.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHTabBar.h"
#import "MHTabBarButton.h"

@interface MHTabBar ()
/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) MHTabBarButton *selectedButton;


/** 设置按钮 */
@property (nonatomic , weak) UIButton *settingButton ;
@end


@implementation MHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 设置子控制器
        [self _setupSubViews];
        
        // 设置设置按钮
        [self _setupSettingButton];
 
    }
    return self;
}


#pragma mark - 初始化
- (void) _setup
{
    self.backgroundColor = MHGlobalViewBackgroundColor;
}

#pragma mark - 设置子控制器
- (void) _setupSubViews
{
    NSArray *buttonNames = @[@"主页" , @"福利" , @"好店" , @"专题"];
    
    NSInteger count = buttonNames.count;
    
    for (NSInteger i = 0; i < count; i++) {
        
        [self _addButtonWithTitleName:buttonNames[i] tag:i];
    }
  
}

#pragma mark - 添加一个按钮
- (void) _addButtonWithTitleName:(NSString *)titleName tag:(NSInteger)tag
{
    MHTabBarButton *button = [[MHTabBarButton alloc] init];

    [button setTitle:titleName forState:UIControlStateNormal];
    
    //???: 按钮选中: 由于Zarker没有提供按钮的图片，这里之前采取的是 新建一个view设置颜色为深红色 加再tabbar身上 但是会遮盖按钮的文字 使得按钮的文字颜色模糊。 体验不好  后来采取根据颜色来生成一张图片  控制按钮的状态来体现按钮的选中 这样效果更好
    
    [button setBackgroundImage:[UIImage imageWithColor:MHGlobalPinkColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:MHGlobalDeepPinkColor] forState:UIControlStateSelected];
    
    button.titleLabel.font = MHMediumFont(14.0f);
    
    button.tag = tag;
    [self addSubview:button];
    
    
    // 监听
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.subviews.count == 1) {
        // 如果是第一个按钮 就选中
        [self _buttonClicked:button];
    }
}
#pragma mark - 按钮点击事件
- (void) _buttonClicked:(MHTabBarButton *)button
{
    // 0.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]
        )
    {
        [self.delegate tabBar:self didSelectButtonFrom:self.selectedButton.tag to:button.tag];
    }
    
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    
    // 2.让新点击的按钮选中
    button.selected = YES;
    
    // 3.新点击的按钮就成为了"当前选中的按钮"
    self.selectedButton = button;
}

#pragma mark - 设置设置按钮
- (void) _setupSettingButton
{
    UIButton *settingButton = [[UIButton alloc] init];
    settingButton.backgroundColor = MHGlobalPinkColor;
    [settingButton setImage:[UIImage imageNamed:@"block_setting_btn"] forState:UIControlStateNormal];
    [self addSubview:settingButton];
    
    self.settingButton = settingButton;
    
    // 监听
    [settingButton addTarget:self action:@selector(_settingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)_settingButtonClicked:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidClickedSettingButton:)]) {
    
        [self.delegate tabBarDidClickedSettingButton:self];

        
    }
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    // 布局
    NSInteger count = self.subviews.count;
    
    // 分割线宽度
    CGFloat separateLineW = .5f;
    
    CGFloat buttonCount = count ;
    
    CGFloat buttonW = (self.frame.size.width -(buttonCount-1)*separateLineW)/buttonCount;
    CGFloat buttonH = self.frame.size.height;
    
    
    // 布局子控件
    for (NSInteger i = 0 ; i < count; i++)
    {
        MHTabBarButton *button = self.subviews[i];
        CGFloat buttonX = (separateLineW + buttonW) *i;
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
    }

    
}


@end
