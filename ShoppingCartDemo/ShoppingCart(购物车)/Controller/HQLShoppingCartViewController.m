//
//  HQLShoppingCartViewController.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShoppingCartViewController.h"

// Frameworks
#import <MJRefresh.h>
#import <Masonry.h>
#import <Chameleon.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

// Proxy
#import "HQLShoppingCartProxy.h"
#import "HQLShoppingCartFormat.h"

// View
#import "HQLShoppingCartCell.h"
#import "HQLShoppingCartHeaderView.h"
#import "HQLShoppingCartSettleView.h"

// Model
#import "HQLStore.h"
#import "HQLShoppingCartManager.h"

// 判断是否为刘海屏
#define IS_NOTCH_SCREEN \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) \
&& (([[UIScreen mainScreen] bounds].size.height == 812.0f) \
|| ([[UIScreen mainScreen] bounds].size.height == 896.0f))

@interface HQLShoppingCartViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, HQLShoppingCartFormatDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HQLShoppingCartSettleView *shoppingCartSettleView;

@property (nonatomic, strong) HQLShoppingCartManager *manager;
@property (nonatomic, strong) HQLShoppingCartProxy *shoppingCartProxy;
@property (nonatomic, strong) HQLShoppingCartFormat *shoppingCartFormat;

@end

@implementation HQLShoppingCartViewController

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"购物车";
        self.manager = [HQLShoppingCartManager sharedManager];
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shoppingCartSettleView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.shoppingCartSettleView.mas_top);
    }];
    
    CGFloat settleVewHeight = IS_NOTCH_SCREEN ? 84 : 50;
    [self.shoppingCartSettleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self.view);
        make.height.mas_equalTo(settleVewHeight);
    }];
}

#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = rgb(249, 249, 249);
        
        // cell 高度设置
        _tableView.estimatedRowHeight = HQLShoppingCartCellHeight;
        _tableView.estimatedSectionHeaderHeight = HQLShoppingCartHeaderViewHeight;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 分割线样式
        
        // 通过 HQLShoppingCartProxy 实例设置 table view 代理
        _tableView.delegate = self.shoppingCartProxy;
        _tableView.dataSource = self.shoppingCartProxy;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        // 注册重用 cell，店铺名称 header view
        [_tableView registerClass:[HQLShoppingCartHeaderView class] forHeaderFooterViewReuseIdentifier:HQLShoppingCartHeaderViewReuserIdentifier];
        
        // 注册重用 cell，商品 cell
        [_tableView registerClass:[HQLShoppingCartCell class] forCellReuseIdentifier:HQLShoppingCartCellReuserIdentifier];
        
        // 设置下拉刷新控件
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestShoppingCartData)];
        // 立即刷新
        // [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (HQLShoppingCartSettleView *)shoppingCartSettleView {
    if (!_shoppingCartSettleView) {
        _shoppingCartSettleView = [[HQLShoppingCartSettleView alloc] init];
        [self updateShoppingCartSettleView];

        // MARK: 全选按钮
        __weak __typeof(self)weakSelf = self;
        _shoppingCartSettleView.allSelectedBlock = ^(BOOL isAllSelected) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.manager selectAllGoods:isAllSelected];
            [strongSelf.tableView reloadData];
            [strongSelf updateShoppingCartSettleView];
        };
        
        // MARK: 结算按钮
        _shoppingCartSettleView.settleGoodsBlock = ^{
            // TODO: 获取选中商品，发起商品结算...
            
        };
    }
    return _shoppingCartSettleView;
}

- (void)updateShoppingCartSettleView {
    [self.shoppingCartSettleView updateWithTotalPrice:_manager.settleTotalPrice
                                               amount:_manager.settleGoodsAmount
                               allSelectedButtonState:_manager.isAllSelected
                                  settleButtonEnabled:_manager.isSettleButtonEnabled];
}

- (HQLShoppingCartProxy *)shoppingCartProxy {
    if (!_shoppingCartProxy) {
        _shoppingCartProxy = [[HQLShoppingCartProxy alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        // MARK: 选中/取消选中当前店铺
        _shoppingCartProxy.selectStoreBlock = ^(BOOL isSelected, NSInteger section) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            // 更新数据模型
            [strongSelf.manager selectStoreInSection:section selectedState:isSelected];
            
            // 更新 UI
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf updateShoppingCartSettleView];
        };
        
        // MARK: 选中/取消选中当前商品
        _shoppingCartProxy.selectGoodsBlock = ^(BOOL isSelected, NSIndexPath * _Nonnull indexPath) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            // 更新数据模型
            [strongSelf.manager selectGoodsAtIndexPath:indexPath selectedState:isSelected];
            
            // 更新 UI
            [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [strongSelf updateShoppingCartSettleView];
        };
        
        // MARK: 点击当前店铺名称，跳转到店铺主页
        _shoppingCartProxy.showStoreBlock = ^(NSInteger section) {
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view.backgroundColor = rgb(230, 230, 255);
            viewController.title = @"店铺";
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        };
        
        // MARK: 点击当前商品，跳转到商品详情页
        _shoppingCartProxy.showGoodsBlock = ^(NSIndexPath * _Nonnull indexPath) {
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view.backgroundColor = rgb(255, 230, 230);
            viewController.title = @"商品详情";
            [weakSelf.navigationController pushViewController:viewController animated:YES];
        };
        
        // MARK: 修改购买商品数量
        _shoppingCartProxy.updateGoodsQuantityBlock = ^(NSIndexPath * _Nonnull indexPath, NSInteger quantity) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            // 更新数据模型
            [strongSelf.manager goodsQuantityChanged:quantity atIndexPath:indexPath];
            
            // 更新 UI
            [strongSelf updateShoppingCartSettleView];
        };
        
        // MARK: 删除商品
        _shoppingCartProxy.deleteGoodsBlock = ^(MGSwipeTableCell * _Nonnull cell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSIndexPath *indexPath = [strongSelf.tableView indexPathForCell:cell];
            
            NSLog(@"indexPath = %@",indexPath);
            NSLog(@"indexPath.section = %ld",indexPath.section);
            NSLog(@"indexPath.row = %ld",indexPath.row);
            
            // 更新数据模型
            [strongSelf.manager deleteGoodsAtIndexPath:indexPath];
            
            // 更新 UI
            [strongSelf.tableView reloadData];
            [strongSelf updateShoppingCartSettleView];
        };
        
        // MARK: 移入收藏夹
        _shoppingCartProxy.collectGoodsBlock = ^(MGSwipeTableCell * _Nonnull cell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSIndexPath *indexPath = [strongSelf.tableView indexPathForCell:cell];
            
            // 更新数据模型
            [strongSelf.manager deleteGoodsAtIndexPath:indexPath];
            
            // 更新 UI
            [strongSelf.tableView reloadData];
            [strongSelf updateShoppingCartSettleView];
            
            // TODO: 将当前商品保存到收藏夹
            // ...
        };
    }
    return _shoppingCartProxy;
}

- (HQLShoppingCartFormat *)shoppingCartFormat {
    if (!_shoppingCartFormat) {
        _shoppingCartFormat = [[HQLShoppingCartFormat alloc] init];
        _shoppingCartFormat.delegate = self;
    }
    return _shoppingCartFormat;
}

#pragma mark - Private

- (void)requestShoppingCartData {
    [self.shoppingCartFormat requestShoppingCartData];
}

#pragma mark - <HQLShoppingCartFormatDelegate>

// 获取购物车数据成功回调
- (void)ShoppingCartFormat:(HQLShoppingCartFormat *)format didReceiveResponse:(NSArray *)dataSourceArray {
    // 通过网络请求数据时，处理成功的回调数据...
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];

}

// 获取购物车数据失败回调
- (void)ShoppingCartFormat:(HQLShoppingCartFormat *)format didFailWithError:(NSError *)error {
    // 通过网络请求数据时，处理失败的回调数据...
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - <DZNEmptyDataSetSource>

// 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"shoppingCart_empty"];
}

// 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"购物车竟然是空的";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
        NSForegroundColorAttributeName:[UIColor darkGrayColor]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"再忙，也要记得买点什么犒赏自己~";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:13],
        NSForegroundColorAttributeName:HexColor(@"#A6A6A6"),
        NSParagraphStyleAttributeName:paragraph
    };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 空白页按钮标题
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"去逛逛";
    UIFont   *font = [UIFont systemFontOfSize:15.0];
    // 设置默认状态、点击高亮状态下的按钮字体颜色
    UIColor *textColor = (state == UIControlStateNormal) ? HexColor(@"00aeef") : HexColor(@"#ffffff");

    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font      forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];

    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 设置内容视图的垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64;
}

// 空白页按钮边框
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *image;
    if (state == UIControlStateNormal) {
        image = [UIImage imageNamed:@"button_background_foursquare_normal"];
    }
    if (state == UIControlStateHighlighted) {
        image = [UIImage imageNamed:@"button_background_foursquare_highlight"];
    }
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}


#pragma mark - <DZNEmptyDataSetDelegate>

// 空白页按钮被点击时调用
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self.tableView.mj_header beginRefreshing];
}


@end
