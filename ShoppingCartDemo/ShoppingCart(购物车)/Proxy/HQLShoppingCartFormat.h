//
//  HQLShoppingCartFormat.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HQLShoppingCartFormat;

NS_ASSUME_NONNULL_BEGIN

@protocol HQLShoppingCartFormatDelegate <NSObject>

@optional

// 获取购物车数据成功回调
- (void)ShoppingCartFormat:(HQLShoppingCartFormat *)format didReceiveResponse:(NSArray *)dataSourceArray;

// 获取购物车数据失败回调
- (void)ShoppingCartFormat:(HQLShoppingCartFormat *)format didFailWithError:(NSError *)error;

@end

/// !!!: 这个类主要负责网络请求、逻辑处理，以及结果的回调
@interface HQLShoppingCartFormat : NSObject

@property (nonatomic, weak) id<HQLShoppingCartFormatDelegate> delegate;

// 获取购物车数据
- (void)requestShoppingCartData;

@end

NS_ASSUME_NONNULL_END
