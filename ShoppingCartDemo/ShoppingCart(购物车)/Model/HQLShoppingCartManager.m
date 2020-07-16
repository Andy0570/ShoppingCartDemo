//
//  HQLShoppingCartManager.m
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLShoppingCartManager.h"
#import <JKCategories.h>
#import "HQLStore.h"

static HQLShoppingCartManager *_sharedManager = nil;

@interface HQLShoppingCartManager ()
@property (nonatomic, readwrite, strong) NSMutableArray<HQLStore *> *mutableStores;
@property (nonatomic, readwrite, assign) NSInteger settleGoodsAmount; // 结算商品数量
@property (nonatomic, readwrite, assign) float settleTotalPrice;      // 结算商品合计价格
@end

@implementation HQLShoppingCartManager

#pragma mark - Initialize

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Custom Accessors

- (NSArray <HQLStore *> *)stores {
    return [_mutableStores mutableCopy];
}

#pragma mark - Public

- (void)selectStoreInSection:(NSInteger)section selectedState:(BOOL)selectedState {
    NSNumber *state = [NSNumber numberWithBool:selectedState];
    
    // 找到当前店铺
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:section];
    currentStore.selectedState = state;
    
    // 同步更新该店铺下所有商品的选中状态
    [currentStore.goods enumerateObjectsUsingBlock:^(HQLGoods *goods, NSUInteger idx, BOOL * _Nonnull stop) {
        goods.selectedState = state;
    }];
    
    [self updateGoodsSettleData];
}

- (void)selectGoodsAtIndexPath:(NSIndexPath *)indexPath selectedState:(BOOL)selectedState {
    NSNumber *state = [NSNumber numberWithBool:selectedState];
    
    // 找到当前店铺和商品
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:indexPath.section];
    HQLGoods *currentGoods = [currentStore.goods jk_objectWithIndex:indexPath.row];
    currentGoods.selectedState = state;
    
    // 遍历该店铺下所有商品的选中状态，反向更新当前店铺的选中状态
    // 如果所有商品都选中，则当前店铺选中，只要有一个商品没有选中，则店铺不选中
    __block BOOL isAllGoodsSelected = YES;
    [currentStore.goods enumerateObjectsUsingBlock:^(HQLGoods *goods, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!goods.selectedState.boolValue) {
            isAllGoodsSelected = NO;
            *stop = YES;
        }
    }];
    // 更新店铺选中状态
    currentStore.selectedState = [NSNumber numberWithBool:isAllGoodsSelected];
    
    [self updateGoodsSettleData];
}

- (void)selectAllGoods:(BOOL)selectedState {
    NSNumber *state = [NSNumber numberWithBool:selectedState];
    
    [_mutableStores enumerateObjectsUsingBlock:^(HQLStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
        store.selectedState = state;
        
        [store.goods enumerateObjectsUsingBlock:^(HQLGoods *goods, NSUInteger idx, BOOL * _Nonnull stop) {
            goods.selectedState = state;
        }];
    }];
    
    [self updateGoodsSettleData];
}

- (void)deleteGoodsAtIndexPath:(NSIndexPath *)indexPath {
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:indexPath.section];
    [currentStore.goods removeObjectAtIndex:indexPath.row];
    
    // 删除该店铺下最后一件商品时，同时删除该店铺
    if (currentStore.goods.count == 0) {
        [_mutableStores removeObject:currentStore];
    }
    
    [self updateGoodsSettleData];
}

- (void)updateGoodsQuantity:(NSInteger)quantity atIndexPath:(NSIndexPath *)indexPath {
    // 找到当前店铺和商品
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:indexPath.section];
    HQLGoods *currentGoods = [currentStore.goods jk_objectWithIndex:indexPath.row];
    
    // 购买商品数量 < 商品库存
    if (quantity <= currentGoods.stock.intValue) {
        currentGoods.quantity = [NSNumber numberWithInteger:quantity];
    }
    
    [self updateGoodsSettleData];
}

- (HQLStore *)storeInSection:(NSInteger)section {
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:section];
    return currentStore;
}

- (HQLGoods *)goodsAtIndexPath:(NSIndexPath *)indexPath {
    HQLStore *currentStore = [_mutableStores jk_objectWithIndex:indexPath.section];
    HQLGoods *currentGoods = [currentStore.goods jk_objectWithIndex:indexPath.row];
    return currentGoods;
}

- (NSArray *)settleSelectedStores {
    [_mutableStores enumerateObjectsUsingBlock:^(HQLStore *currentStore, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!currentStore.selectedState.boolValue) {
            [_mutableStores removeObject:currentStore];
        } else {
            [currentStore.goods enumerateObjectsUsingBlock:^(HQLGoods *currentGoods, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!currentGoods.selectedState.boolValue) {
                    [currentStore.goods removeObject:currentGoods];
                }
            }];
        }
    }];
    
    return [_mutableStores mutableCopy];
}

#pragma mark - Private

// !!!: 出于演示目的，此处从 plist 文件中加载商品数据，正式环境下需要从网络获取
- (void)loadShoppingCartGoods {
    // 1.构造 shoppingCartGoods.plist 文件 URL 路径
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSURL *url = [bundleURL URLByAppendingPathComponent:@"shoppingCartGoods.plist"];
    
    // 2.读取 shoppingCartGoods.plist 文件，并存放进 jsonArray 数组
    NSArray *jsonArray;
    if (@available(iOS 11.0, *)) {
        NSError *readFileError = nil;
        jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
        NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
    } else {
        jsonArray = [NSArray arrayWithContentsOfURL:url];
        NSAssert(jsonArray, @"NSPropertyList File read error.");
    }
    
    // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellStyleDefaultModel 模型
    NSError *decodeError = nil;
    NSArray *dataSourceArray = [MTLJSONAdapter modelsOfClass:HQLStore.class
                                               fromJSONArray:jsonArray
                                                       error:&decodeError];
    NSAssert1(dataSourceArray, @"JSONArray decode error:\n%@", decodeError);
    
    self.mutableStores = [NSMutableArray arrayWithArray:dataSourceArray];
}

// 更新商品结算数据
- (void)updateGoodsSettleData {
    
    // 1.重置所有结算数据
    self.settleGoodsAmount = 0;    // 结算商品数量
    self.settleTotalPrice = 0.f;   // 结算商品合计价格
    self.selectedState = YES;      // 是否全选
    self.settleButtonEnabled = NO; // 是否开启结算按钮
    
    // 如果没有商品数据，返回
    if (self.mutableStores.count ==0) {
        self.selectedState = NO;
        return;
    }
    
    // 2.遍历数据源
    [self.mutableStores enumerateObjectsUsingBlock:^(HQLStore *currentStore, NSUInteger idx, BOOL * _Nonnull stop) {
        [currentStore.goods enumerateObjectsUsingBlock:^(HQLGoods *currentGoods, NSUInteger idx, BOOL * _Nonnull stop) {
            if (currentGoods.selectedState.boolValue) {
                float currentGoodsPrice = currentGoods.price.floatValue;
                int quantity = currentGoods.quantity.intValue;
                self.settleGoodsAmount += quantity;
                self.settleTotalPrice += currentGoodsPrice * quantity;
                
                // 只要有一件商品是选中的，就允许结算，
                // TODO: 根据业务需求，如果选中的商品没有库存，也不允许结算
                self.settleButtonEnabled = YES;
            } else {
                self.selectedState = NO;
            }
        }];
    }];
}

@end
