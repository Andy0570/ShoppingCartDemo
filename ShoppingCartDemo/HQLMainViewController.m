//
//  HQLMainViewController.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/6/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainViewController.h"

@interface HQLMainViewController ()

@end

@implementation HQLMainViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK: 添加导航栏购物车按钮
    [self addNavigationShoppingCartButton];
}

#pragma mark - Private

- (void)addNavigationShoppingCartButton {
    UIBarButtonItem *shoppingCartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_shopping_cart"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationShoppingCartButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = shoppingCartButton;
}

#pragma mark - Actions

- (void)navigationShoppingCartButtonDidClicked:(id)sender {
    
}



@end
