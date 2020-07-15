//
//  HQLShoppingCartSettleView.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 购物车底部，全选按钮点击 Block
typedef void(^ShoppingCartSelectAllGoodsBlock)(BOOL isAllSelected);

/// 购物车底部结算视图
@interface HQLShoppingCartSettleView : UIView

// 全选按钮点击事件
@property (nonatomic, copy) ShoppingCartSelectAllGoodsBlock allSelectedBlock;
@property (nonatomic, copy) dispatch_block_t settleGoodsBlock;

/// 更新购物车底部按钮视图 UI
/// @param totalPrice 商品合计金额
/// @param amount 商品数量
/// @param isAllSelected 是否全选
/// @param isEnabled 结算按钮是否可用
- (void)updateWithTotalPrice:(float)totalPrice
                      amount:(NSInteger)amount
      allSelectedButtonState:(BOOL)isAllSelected
         settleButtonEnabled:(BOOL)isEnabled;

@end

NS_ASSUME_NONNULL_END
