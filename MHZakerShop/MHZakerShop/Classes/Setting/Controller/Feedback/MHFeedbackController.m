//
//  MHFeedbackController.m
//  MHZakerShop
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHFeedbackController.h"
#import "MHBottomToolBar.h"
#import <WebKit/WebKit.h>
@interface MHFeedbackController () <WKNavigationDelegate>

@end

@implementation MHFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
    
    // 创建webView
    [self _setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)_setup
{
    // 设置标题
    self.bottomToolBar.title = @"反馈/建议";
}

#pragma mark - 创建webView
- (void) _setupWebView
{
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -44, 0);
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:@"http://showcase.myzaker.com/phone/feedback.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.navigationDelegate = self;
    [self.view insertSubview:webView belowSubview:self.bottomToolBar];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    MHLogFunc;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    MHLogFunc;
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    MHLogFunc;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    MHLogFunc;
}


@end
