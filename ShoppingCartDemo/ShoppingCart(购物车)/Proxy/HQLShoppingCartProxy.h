//
//  HQLShoppingCartProxy.h
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

NS_ASSUME_NONNULL_BEGIN

// 选中/取消选中当前店铺
typedef void(^ShoppingCartProxySelectStoreHandler)(NSInteger section, BOOL isSelected);

// 选中/取消选中当前商品
typedef void(^ShoppingCartProxySelectGoodsHandler)(NSIndexPath *indexPath, BOOL isSelected);

// 点击当前店铺名称，跳转到店铺主页
typedef void(^ShoppingCartProxyShowStoreHandler)(NSInteger section);

// 点击当前商品，跳转到商品详情页
typedef void(^ShoppingCartProxyShowGoodsHandler)(NSIndexPath *indexPath);

// 修改购买商品数量
typedef void(^ShoppingCartProxyUpdateGoodsQuantityHandler)(NSIndexPath *indexPath, NSInteger quantity);

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
@property (nonatomic, copy) ShoppingCartProxyUpdateGoodsQuantityHandler updateGoodsQuantityBlock;
@property (nonatomic, copy) ShoppingCartProxyDeleteGoodsHandler deleteGoodsBlock;
@property (nonatomic, copy) ShoppingCartProxyCollectGoodsHandler collectGoodsBlock;

@end

NS_ASSUME_NONNULL_END
