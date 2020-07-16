//
//  HQLShoppingCartFormat.h
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HQLShoppingCartFormatDelegate <NSObject>

@optional

// 获取购物车数据成功回调
- (void)shoppingCartFormatDidReceiveResponse:(NSArray *)dataSourceArray;

// 获取购物车数据失败回调
- (void)shoppingCartFormatDidFailWithError:(NSError *)error;

@end

/// !!!: 这个类主要负责网络请求、逻辑处理，以及结果的回调
@interface HQLShoppingCartFormat : NSObject

@property (nonatomic, weak) id<HQLShoppingCartFormatDelegate> delegate;

// 获取购物车数据
- (void)requestShoppingCartData;

@end

NS_ASSUME_NONNULL_END
