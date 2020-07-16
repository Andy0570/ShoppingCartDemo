//
//  HQLStore.m
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLStore.h"

@implementation HQLGoods

#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (!self) return nil;

    // 商品默认选中状态：未选中
    _selectedState = [NSNumber numberWithBool:NO];

    return self;
}

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userId"        : @"userId",
        @"storeId"       : @"storeId",
        @"goodsId"       : @"goodsId",
        @"storeName"     : @"storeName",
        @"goodsName"     : @"goodsName",
        @"imageURL"      : @"imageURL",
        @"quantity"      : @"quantity",
        @"price"         : @"price",
        @"stock"         : @"stock",
        @"specification" : @"specification",
        @"selectedState" : @"selectedState"
    };
}

// imageURL
// JSON String <——> NSURL
+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end


@implementation HQLStore

#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (!self) return nil;

    // 店铺默认选中状态：未选中
    _selectedState = [NSNumber numberWithBool:NO];

    return self;
}

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"storeId"       : @"storeId",
        @"storeName"     : @"storeName",
        @"selectedState" : @"selectedState",
        @"goods"         : @"goods"
    };
}

// goods
// JSON Object <——> 对象类型
+ (NSValueTransformer *)goodsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLGoods.class];
}

@end
