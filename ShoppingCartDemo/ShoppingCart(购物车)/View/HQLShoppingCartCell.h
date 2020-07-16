//
//  HQLShoppingCartCell.h
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <MGSwipeTableCell.h>
@class HQLGoods;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLShoppingCartCellHeight;
UIKIT_EXTERN NSString *const HQLShoppingCartCellReuserIdentifier;

// 购物袋商品 cell 单选按钮点击 Block
typedef void(^ShoppingCartSelectGoodsBlock)(BOOL isSelected);

// 修改商品数量
typedef void(^ShoppingCartUpdateGoodsQuantityBlock)(NSInteger quantity);

/// 购物袋商品 cell
@interface HQLShoppingCartCell : MGSwipeTableCell

@property (nonatomic, strong) HQLGoods *goods;
@property (nonatomic, copy) ShoppingCartSelectGoodsBlock selectGoodsBlock;
@property (nonatomic, copy) ShoppingCartUpdateGoodsQuantityBlock updateGoodsQuantityBlock;

@end

NS_ASSUME_NONNULL_END
