//
//  HQLShoppingCartProxy.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShoppingCartProxy.h"

// Framework
#import <Chameleon.h>

// Views
#import "HQLShoppingCartCell.h"
#import "HQLShoppingCartHeaderView.h"

// Models
#import "HQLStore.h"
#import "HQLShoppingCartManager.h"

@interface HQLShoppingCartProxy () <MGSwipeTableCellDelegate>
@property (nonatomic, strong) HQLShoppingCartManager *manager;
@end

@implementation HQLShoppingCartProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [HQLShoppingCartManager sharedManager];
    }
    return self;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.manager.stores.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLStore *currentStore = self.manager.stores[section];
    return currentStore.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HQLShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:HQLShoppingCartCellReuserIdentifier forIndexPath:indexPath];
    
    // 1.从数据源中找到当前购物车店铺模型
    HQLStore *currentStore = self.manager.stores[indexPath.section];
    // 2.找到当前商品模型
    HQLGoods *currentGoods = currentStore.goods[indexPath.row];
    // 3.通过商品数据模型更新 UI
    cell.goods = currentGoods;
    
    // MARK: 选中/取消选中当前商品
    __weak __typeof(self)weakSelf = self;
    cell.selectButtonActionBlock = ^(BOOL isSelected) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        // 向外传递消息，刷新 UI
        if (strongSelf.selectGoodsBlock) {
            strongSelf.selectGoodsBlock(isSelected, indexPath);
        }
    };
    
    // MARK: 修改商品数量
    cell.goodsQuantityChangedBlock = ^(NSInteger quantity) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // 向外传递消息，刷新 UI
        if (strongSelf.goodsQuantityChangedBlock) {
            strongSelf.goodsQuantityChangedBlock(indexPath, quantity);
        }
    };
    
    // MARK: 删除按钮
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:rgb(233, 80, 60)];
    deleteButton.buttonWidth = 50;
    
    // MARK: 收藏按钮
    MGSwipeButton *collectButton = [MGSwipeButton buttonWithTitle:@"收藏" backgroundColor:rgb(237, 118, 45)];
    collectButton.buttonWidth = 50;
    
    cell.rightButtons = @[deleteButton, collectButton];
    cell.delegate = self;

    return cell;
}

#pragma mark - <UITableViewDelegate>

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HQLShoppingCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HQLShoppingCartHeaderViewReuserIdentifier];
    
    // 1.从数据源中找到当前购物车店铺模型
    HQLStore *currentStore = self.manager.stores[section];
    // 2. 配置 header view 数据模型
    [headerView updateWithStoreName:currentStore.storeName selectedState:currentStore.selectedState.boolValue];
    
    // MARK: 选中/取消选中当前店铺
    __weak __typeof(self)weakSelf = self;
    headerView.selectButtonActionBlock = ^(BOOL isSelected) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        // 向外传递消息，刷新 UI
        if (strongSelf.selectStoreBlock) {
            strongSelf.selectStoreBlock(isSelected, section);
        }
    };
    
    // MARK: 点击店铺标题，跳转到店铺主页
    headerView.titleButtonActionBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;

        // 通过 Block 向外传递事件
        if (strongSelf.showStoreBlock) {
            strongSelf.showStoreBlock(section);
        }
    };
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // MARK: 点击商品，跳转到商品详情页
    if (self.showGoodsBlock) {
        self.showGoodsBlock(indexPath);
    }
}

#pragma mark - <MGSwipeTableCellDelegate>

/**
 说明：
 
 你也可以在创建 MGSwipeButton 对象时，通过内联 Block 方式接收按钮点击事件，而不是通过这里的可选 Delegate 方式。
 但是因为 MGSwipeButton 按钮是按需创建的，通过 Delegate 的方式接收按钮点击事件可以提升内存使用效率（节省内存）。
 
 以上在 MGSwipeTableCell 框架的 README 文档中有提及。
 */
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    
    NSLog(@"cell = %@",cell);
    NSLog(@"index = %ld",index);
    
    
    // MARK: 删除按钮点击处理事件
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        
        if (self.deleteGoodsBlock) {
            self.deleteGoodsBlock(cell);
            return NO;
        }
    }
    
    // MARK: 收藏按钮点击处理事件
    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
        
        if (self.collectGoodsBlock) {
            self.collectGoodsBlock(cell);
            return NO;
        }
    }
    
    return YES;
}


@end
