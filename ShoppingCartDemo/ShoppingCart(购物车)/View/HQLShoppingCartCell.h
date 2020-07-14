//
//  HQLShoppingCartCell.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>
@class HQLGoods;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLShoppingCartCellHeight;
UIKIT_EXTERN NSString *const HQLShoppingCartCellReuserIdentifier;

// 购物袋商品 cell 单选按钮点击 Block
typedef void(^ShoppingCartCellSelectButtonActionBlock)(BOOL isSelected);

// 修改商品数量
typedef void(^ShoppingCartGoodsQuantityChangedBlock)(NSInteger quantity);

/// 购物袋商品 cell
@interface HQLShoppingCartCell : MGSwipeTableCell

@property (nonatomic, strong) HQLGoods *goods;
@property (nonatomic, copy) ShoppingCartCellSelectButtonActionBlock selectButtonActionBlock;
@property (nonatomic, copy) ShoppingCartGoodsQuantityChangedBlock goodsQuantityChangedBlock;

@end

NS_ASSUME_NONNULL_END
