//
//  HQLShoppingCartFormat.m
//  ProjectName
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLShoppingCartFormat.h"

// Model
#import "HQLStore.h"
#import "HQLShoppingCartManager.h"

// 该结构体用于缓存委托对象是否能响应特定的选择子
typedef struct {
    unsigned int didReceiveResponse : 1;
    unsigned int didFailWithError   : 1;
} DelegateFlags;

@interface HQLShoppingCartFormat ()
@property (nonatomic, assign) DelegateFlags delegateFlag;
@end

@implementation HQLShoppingCartFormat

#pragma mark - Custom Accessors

- (void)setDelegate:(id<HQLShoppingCartFormatDelegate>)delegate {
    _delegate = delegate;
    
    // 提前缓存方法的响应能力
    _delegateFlag.didReceiveResponse = [delegate respondsToSelector:@selector(shoppingCartFormatDidReceiveResponse:)];
    _delegateFlag.didFailWithError = [delegate respondsToSelector:@selector(shoppingCartFormatDidFailWithError:)];
}

#pragma mark - Public

- (void)requestShoppingCartData {
    // FIXME: 为便于演示，这里暂时使用本地数据代替
    [[HQLShoppingCartManager sharedManager] loadShoppingCartGoods];
    
    // 请求数据成功之后的回调
    if (_delegateFlag.didReceiveResponse) {
        [self.delegate shoppingCartFormatDidReceiveResponse:[HQLShoppingCartManager sharedManager].stores];
    }
}


@end
