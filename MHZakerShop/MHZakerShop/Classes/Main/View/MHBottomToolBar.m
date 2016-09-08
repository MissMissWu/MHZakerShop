//
//  MHBottomToolBar.m
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHBottomToolBar.h"

@interface MHBottomToolBar ()
// 主题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


// 网络浏览的 翻页view
@property (weak, nonatomic) IBOutlet UIView *webPageView;


// 左翻页
@property (weak, nonatomic) IBOutlet UIButton *leftPageBtn;

// 右翻页
@property (weak, nonatomic) IBOutlet UIButton *rightPageBtn;


// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end


@implementation MHBottomToolBar

+ (instancetype)bottomToolBar
{
    return [self mh_viewFromXib];
}

- (void)awakeFromNib
{
    // 初始化
    [self _setup];
    
}
#pragma mark - 初始化
- (void) _setup
{
    //隐藏
    self.webPageView.hidden = YES;
    _hiddenWebPageView = YES;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = title;
}

- (void)setHiddenWebPageView:(BOOL)hiddenWebPageView
{
    if (_hiddenWebPageView !=hiddenWebPageView) {
        _hiddenWebPageView = hiddenWebPageView;
        
        self.webPageView.hidden = hiddenWebPageView;
    }
}

// 关闭按钮被点击
- (IBAction)_closeButtonClicked:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(bottomToolBarDidClickedCloseButton:)]){
        [self.delegate bottomToolBarDidClickedCloseButton:self];
    }
    
    !self.closeButtonDidCliked?:self.closeButtonDidCliked(self);
    
}

// 翻页
- (IBAction)_pageClicked:(UIButton *)sender
{
    
    MHWebViewPageType pageType = sender.tag;
    
    MHLog(@"----  %zd" , pageType);
    
    // 回调代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomToolBar:pageButtonDidClicked:)]) {
        
        [self.delegate bottomToolBar:self pageButtonDidClicked:pageType];
    }
    
    // block 回调
    !self.pageButtonDidClicked?:self.pageButtonDidClicked(self , pageType);
    
}


/**
 
 
 //FIXME:  xib 小问题
 
 *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<NSObject 0x1565fdf0> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key leftPageBtn.'
 ***
   这个一般是连线问题 去掉连线  或者 把App卸载重装
 */
@end
