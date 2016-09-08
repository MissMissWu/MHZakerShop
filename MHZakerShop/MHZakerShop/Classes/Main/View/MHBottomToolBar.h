//
//  MHBottomToolBar.h
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//  底部操作工作条

#import <UIKit/UIKit.h>

@class MHBottomToolBar;

@protocol MHBottomToolBarDelegate <NSObject>

@optional
// x 按钮被点击
- (void)bottomToolBarDidClickedCloseButton:(MHBottomToolBar *)bottomToolBar;

// 翻页按钮被点击
- (void)bottomToolBar:(MHBottomToolBar *)bottomToolBar pageButtonDidClicked:(MHWebViewPageType)pageType;

@end

@interface MHBottomToolBar : UIView

+ (instancetype)bottomToolBar;


/** 代理 */
@property (nonatomic , weak) id<MHBottomToolBarDelegate> delegate;

// block监听
/** close按钮被点击 */
@property (nonatomic , copy) void (^closeButtonDidCliked)(MHBottomToolBar *bottomToolBar);

/** 翻页按钮被点击 */
@property (nonatomic , copy) void (^pageButtonDidClicked)(MHBottomToolBar *bottomToolBar , MHWebViewPageType pageType);



// 属性
/** 是否需要隐藏左侧针对webView的操作条 */
@property (nonatomic , assign , getter = isHiddenWebPageView) BOOL hiddenWebPageView;
/** 主题 */
@property (nonatomic , copy) NSString *title;


@end
