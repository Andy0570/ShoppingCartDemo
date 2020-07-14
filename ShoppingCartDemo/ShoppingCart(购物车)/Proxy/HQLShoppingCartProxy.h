//
//  HQLShoppingCartProxy.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

NS_ASSUME_NONNULL_BEGIN

// 选中/取消选中当前店铺
typedef void(^ShoppingCartProxySelectStoreHandler)(BOOL isSelected, NSInteger section);

// 选中/取消选中当前商品
typedef void(^ShoppingCartProxySelectGoodsHandler)(BOOL isSelected, NSIndexPath *indexPath);

// 点击当前店铺名称，跳转到店铺主页
typedef void(^ShoppingCartProxyShowStoreHandler)(NSInteger section);

// 点击当前商品，跳转到商品详情页
typedef void(^ShoppingCartProxyShowGoodsHandler)(NSIndexPath *indexPath);

// 修改购买商品数量
typedef void(^ShoppingCartProxyGoodsQuantityChangedHandler)(NSIndexPath *indexPath, NSInteger quantity);

// 删除商品
typedef void(^ShoppingCartProxyDeleteGoodsHandler)(MGSwipeTableCell *cell);

// 移入收藏夹
typedef void(^ShoppingCartProxyCollectGoodsHandler)(MGSwipeTableCell *cell);

// TODO: 修改商品参数


// !!!: 购物车列表视图控制器 DataSource、Delegate 代理
@interface HQLShoppingCartProxy : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) ShoppingCartProxySelectStoreHandler selectStoreBlock;
@property (nonatomic, copy) ShoppingCartProxySelectGoodsHandler selectGoodsBlock;
@property (nonatomic, copy) ShoppingCartProxyShowStoreHandler showStoreBlock;
@property (nonatomic, copy) ShoppingCartProxyShowGoodsHandler showGoodsBlock;
@property (nonatomic, copy) ShoppingCartProxyGoodsQuantityChangedHandler goodsQuantityChangedBlock;
@property (nonatomic, copy) ShoppingCartProxyDeleteGoodsHandler deleteGoodsBlock;
@property (nonatomic, copy) ShoppingCartProxyCollectGoodsHandler collectGoodsBlock;

@end

NS_ASSUME_NONNULL_END
