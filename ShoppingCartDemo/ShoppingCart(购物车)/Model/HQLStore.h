//
//  HQLStore.h
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 商品模型
@interface HQLGoods : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *userId;
@property (nonatomic, readonly, strong) NSNumber *storeId;
@property (nonatomic, readonly, strong) NSNumber *goodsId;
@property (nonatomic, readonly, copy) NSString *storeName;
@property (nonatomic, readonly, copy) NSString *goodsName;
@property (nonatomic, readonly, strong) NSURL  *imageURL;
@property (nonatomic, readwrite, strong) NSNumber *quantity;
@property (nonatomic, readonly, strong) NSNumber *price;
@property (nonatomic, readonly, strong) NSNumber *stock;
@property (nonatomic, readonly, copy) NSString *specification;
@property (nonatomic, readwrite, strong) NSNumber *selectedState;

@end

/// 购物车商品模型
@interface HQLStore : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *storeId;
@property (nonatomic, readonly, copy) NSString *storeName;
@property (nonatomic, readwrite, strong) NSNumber *selectedState;
@property (nonatomic, readwrite, strong) NSMutableArray<HQLGoods *> *goods;

@end

NS_ASSUME_NONNULL_END
