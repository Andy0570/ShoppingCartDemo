//
//  AppDelegate.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/6/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+CYLTabBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self hql_configureForTabBarController];
    return YES;
}

@end
