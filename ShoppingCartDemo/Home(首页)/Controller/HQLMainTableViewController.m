//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <Mantle.h>

// Controller
#import "HQLShoppingCartViewController.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray<HQLTableViewCellStyleDefaultModel *> *dataSourceArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
    
    // MARK: 添加导航栏购物车按钮
    [self addNavigationShoppingCartButton];
}


#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewCellStyleDefaultModel *> *)dataSourceArray {
    if (!_dataSourceArray) {

        // 1.构造 mainTableViewTitleModel.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"mainTableViewTitleModel.plist"];
        
        // 2.读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            NSAssert(jsonArray, @"NSPropertyList File read error.");
        }
        
        // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellGroupedModel 模型
        NSError *decodeError = nil;
        _dataSourceArray = [MTLJSONAdapter modelsOfClass:HQLTableViewCellGroupedModel.class
                                     fromJSONArray:jsonArray
                                             error:&decodeError];
        NSAssert1(_dataSourceArray, @"JSONArray decode error:\n%@", decodeError);
    }
    return _dataSourceArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

- (void)addNavigationShoppingCartButton {
    UIBarButtonItem *shoppingCartButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_shopping_cart"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationShoppingCartButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = shoppingCartButton;
}


#pragma mark - Actions

- (void)navigationShoppingCartButtonDidClicked:(id)sender {
    
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        HQLShoppingCartViewController *shoppingCartVC = [[HQLShoppingCartViewController alloc] init];
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }
}

@end
