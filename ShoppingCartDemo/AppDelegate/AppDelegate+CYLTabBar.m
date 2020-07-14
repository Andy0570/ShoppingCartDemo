//
//  AppDelegate+CYLTabBar.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate+CYLTabBar.h"

// Framework
#import <CYLTabBarController.h>

// Controller
#import "HQLMainTableViewController.h"
#import "HQLSearchViewController.h"
#import "HQLMessageViewController.h"
#import "HQLMineViewController.h"

@implementation AppDelegate (CYLTabBar)

#pragma mark - Public

- (void)hql_configureForTabBarController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 初始化 CYLTabBarController 对象
    CYLTabBarController *tabBarController =
        [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                           tabBarItemsAttributes:[self tabBarItemsAttributes]];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 自定义 TabBar 字体、背景、阴影
    [self customizeTabBarInterface];
}

#pragma mark - Private

// MARK: 视图控制器数组
- (NSArray *)viewControllers {
    // 首页
    HQLMainTableViewController *mainVC = [[HQLMainTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    mainVC.navigationItem.title = @"首页";
    CYLBaseNavigationController *mainNC = [[CYLBaseNavigationController alloc] initWithRootViewController:mainVC];
    
    // 搜索
    HQLSearchViewController *searchVC = [[HQLSearchViewController alloc] init];
    searchVC.navigationItem.title = @"搜索";
    CYLBaseNavigationController *searchNC = [[CYLBaseNavigationController alloc] initWithRootViewController:searchVC];
    
    // 消息
    HQLMessageViewController *messageVC = [[HQLMessageViewController alloc] init];
    messageVC.navigationItem.title = @"消息";
    CYLBaseNavigationController *messageNC = [[CYLBaseNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    HQLMineViewController *mineVC = [[HQLMineViewController alloc] init];
    mineVC.navigationItem.title = @"我的";
    CYLBaseNavigationController *mineNC = [[CYLBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    NSArray *viewControllersArray = @[mainNC, searchNC, messageNC, mineNC];
    return viewControllersArray;
}

// MARK: tabBar 属性数组
- (NSArray *)tabBarItemsAttributes {
    NSDictionary *mainTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"首页",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_home_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *newsTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"搜索",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_search_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *lawTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"消息",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_message_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *mineTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"我的",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_me_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    
    NSArray *tabBarItemsAttributes = @[
        mainTabBarItemsAttributes,
        newsTabBarItemsAttributes,
        lawTabBarItemsAttributes,
        mineTabBarItemsAttributes
    ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarInterface {
    // 设置文字属性
    if (@available(iOS 10.0, *)) {
        // [self cyl_tabBarController].tabBar.unselectedItemTintColor = [UIColor blackColor];
        [self cyl_tabBarController].tabBar.tintColor = [UIColor blackColor];
    } else {
        UITabBarItem *tabBar = [UITabBarItem appearance];
        // 普通状态下的文字属性
        [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]}
                              forState:UIControlStateNormal];
        // 选中状态下的文字属性
        [tabBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}
                              forState:UIControlStateSelected];
    }
}

@end
