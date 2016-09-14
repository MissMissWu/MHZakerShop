//
//  MHShopController.m
//  MHZakerShop
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHShopController.h"

@interface MHShopController ()

@end

@implementation MHShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    [self _setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化
- (void)_setup
{
    self.dismissEnabled = NO;
}

@end
