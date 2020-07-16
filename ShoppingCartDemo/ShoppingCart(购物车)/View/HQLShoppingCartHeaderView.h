//
//  HQLShoppingCartHeaderView.h
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLShoppingCartHeaderViewHeight;
UIKIT_EXTERN NSString *const HQLShoppingCartHeaderViewReuserIdentifier;

/// 选中店铺下所有商品 Block
typedef void(^ShoppingCartSelectStoreBlock)(BOOL isSelected);

/// 购物车 - 带店铺标题的 header view
@interface HQLShoppingCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) ShoppingCartSelectStoreBlock selectStoreBlock;
@property (nonatomic, copy) dispatch_block_t showStoreBlock;

/// 更新 header view
/// @param storeName 店铺名称
/// @param state 当前店铺下所有商品的选中状态
- (void)updateStoreName:(NSString *)storeName selectedState:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
