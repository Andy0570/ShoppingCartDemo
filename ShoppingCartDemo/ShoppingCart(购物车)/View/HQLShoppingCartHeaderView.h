//
//  HQLShoppingCartHeaderView.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLShoppingCartHeaderViewHeight;
UIKIT_EXTERN NSString *const HQLShoppingCartHeaderViewReuserIdentifier;

/// 选中店铺下所有商品 Block
typedef void(^ShoppingCartHeaderViewSelectButtonActionBlock)(BOOL isSelected);

/// 购物车 - 带店铺标题的 header view
@interface HQLShoppingCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) ShoppingCartHeaderViewSelectButtonActionBlock selectButtonActionBlock;
@property (nonatomic, copy) dispatch_block_t titleButtonActionBlock;

/// 更新 header view
/// @param storeName 店铺名称
/// @param isSelected 当前店铺下所有商品的选中状态
- (void)updateWithStoreName:(NSString *)storeName selectedState:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
