//
//  MHTopicController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHTopicController.h"

@interface MHTopicController ()

@end

@implementation MHTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self _setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化
- (void)_setup
{
    self.dismissEnabled = NO;
}

@end
