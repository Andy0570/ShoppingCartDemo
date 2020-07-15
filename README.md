# ShoppingCartDemo

<p align="center" >
  <img src="https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/093300.jpg" alt="ShoppingCartDemo" title="ShoppingCartDemo">
</p>


[![Platform](https://img.shields.io/badge/platform-ios-lightgrey)](https://developer.apple.com/iphone/)
[![Language](https://img.shields.io/badge/language-Objective--C-informational)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![Lincese](https://img.shields.io/badge/License-MIT-informational)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

## 目录

* [背景](#背景)
* [功能特点](#功能特点)
* [要求](#要求)
* [第三方依赖](#第三方依赖)
* [实现说明](#实现说明)
* [使用说明](#使用说明)
* [如何贡献](#如何贡献)
* [使用许可](#使用许可)

## 背景

本项目为 iOS 应用中电商项目下的购物车页面示例。

本项目[源码](https://github.com/Andy0570/ShoppingCartDemo)

**声明：本项目源码仅用于学习交流！**


## 功能特点

- [x] 按照店铺名称，分组展示购物车商品；
- [x] 点击店铺标题，跳转到店铺详情页面；
- [x] 点击商品名称，跳转到商品详情页面；
- [x] 购物车商品为空时，展示空白页面提示信息；
- [x] 添加下拉刷新控件；
- [x] 支持任意单个商品的选中和取消选中；
- [x] 支持店铺下所有商品的选中和取消选中；
- [x] 支持所有商品的选中和取消选中；
- [x] 通过加（`+`）减（`-`）按钮设置商品数量；
- [x] 购物车底部视图：全选商品按钮、自动计算并显示商品数量、自动计算并显示商品合计价格、购物车商品结算按钮；
- [x] 单个商品管理功能，通过滑动手势向左滑动购物车列表中的商品，实现单个商品的收藏、删除功能。
- [ ] 批量商品管理，勾选指定商品或全部商品后，一键移入收藏夹、删除商品。
- [ ] 修改商品规格功能。


## 要求

- iOS 10.0+
- Xcode 11.5



## 第三方依赖

作为新时代的开发者，我们应该纯粹地感到幸福，因为我们可以站在巨人的肩膀上。本项目的完整实现得益于以下开源项目的支持：

* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - 显示购物车商品图片；
* [MJRefresh](https://github.com/CoderMJLee/MJRefresh) - 下拉刷新控件；
* [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - 显示加载动画 HUD，发起网络请求或者弹窗时可能需要用到。
* [Toast](https://github.com/scalessec/Toast) - 弹窗提示框架。
* [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) - 实现购物车空白页面效果；
* [MGSwipeTableCell](https://github.com/MortimerGoro/MGSwipeTableCell) - 实现商品的左滑收藏、删除功能；
* [BEMCheckBox](https://github.com/Boris-Em/BEMCheckBox) - 单选按钮功能，实现购物车下单个商品、单个店铺、所有商品的选中/取消选中效果；
* [PPNumberButton](https://github.com/jkpang/PPNumberButton) - iOS 中一款高度可定制性商品计数按钮 (京东 / 淘宝 / 饿了么 / 美团外卖 / 百度外卖样式)，实现商品数量的增减；
* [Masonry](https://github.com/SnapKit/Masonry) - 自动布局框架；
* [Mantle](https://github.com/Mantle/Mantle)  - Cocoa & Cocoa Touch 的模型框架；
* [YYKit](https://github.com/ibireme/YYKit) - iOS 工具类组件；
* [JKCategories](https://github.com/shaojiankui/JKCategories) - iOS 的 Category 范畴类集合；
* [Chameleon](https://github.com/viccalexander/Chameleon) - 颜色框架，提供了很多便捷方法设置 UI 颜色；
* [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)  - 一行代码实现 Lottie 动画 TabBar，支持中间带 + 号的 TabBar 样式，自带红点角标，支持动态刷新（可有可无，引入此框架纯粹为了搭建 Demo 应用框架）。



## 实现说明

### 友好的空白页面

本项目中集成了 [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet) 框架，当购物车中没有商品时，在空白页面显示提示信息，提升用户体验。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/100715.png)

### 商品选中/取消选中

购物车中，商品的单选按钮实现逻辑如下：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/094123.gif)

* 单选按钮通过集成 [BEMCheckBox](https://github.com/Boris-Em/BEMCheckBox)  框架实现；
* 选择/取消选择商品时，自动更新底部结算条上的商品数量和合计金额；
* 根据当前购物车中所有商品的选中状态，自动同步更新底部结算条上的全选按钮；
* 选择/取消选择商品时，如果该商品所对应的店铺下所有商品都被选中或者全部被取消选中了，自动同步更新该店铺的选中状态；

### 修改商品数量

在购物车页面中，支持修改单个商品数量。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/094905.gif)

* 集成 [PPNumberButton](https://github.com/jkpang/PPNumberButton)  框架，实现商品数量的增减按钮；
* 商品数量的最小值（`minValue`）为 1，最大值（`maxValue`）为当前商品库存；
* 修改商品数量时，自动更新底部结算条上的合计金额；



### 商品收藏、删除功能

支持在任意商品上，通过左滑手势实现商品移入收藏夹、删除商品功能：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/100804.png)

* 集成 [MGSwipeTableCell](https://github.com/MortimerGoro/MGSwipeTableCell) 框架，实现商品的左滑收藏、删除功能；
* 删除商品后，自动更新底部的结算条商品数量和商品金额；

默认情况下，如果要删除某一个 section 下的 cell，通过以下代码即可实现：
```objectivec
NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
[self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
```

但是当这个 section 下只有一个 cell 时，也就是，这家店铺下只有这一件商品，当我们删除了这件商品后，这家店铺同时也要删除。因此，删除商品后，更新 UI 我使用了 `[self.tableView reloadData]` 刷新了整个购物车列表。



### 店铺主页、商品详情页面跳转功能

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/094821.gif)

* 点击店铺名称时，跳转到店铺主页；
* 点击商品时，跳转到商品详情页；

## 使用说明

### 实现架构

购物车页面逻辑遵循 MVC 设计模式。并且尽量按照**高内聚**、**低耦合**的设计原则分离代码。

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/095759.png)



Controller：

* **HQLShoppingCartViewController**：购物车页面的主视图控制器。

View：

* **HQLShoppingCartCell**：是 `MGSwipeTableCell` 的子类对象。通过手写代码实现的购物袋商品 cell，使用 [Masonry](https://github.com/SnapKit/Masonry) 框架实现 UI 自动布局，使用 [BEMCheckBox](https://github.com/Boris-Em/BEMCheckBox) 框架在 Cell 上添加了一个单选按钮。作为 `MGSwipeTableCell` 的子类对象是因为需要使用 [MGSwipeTableCell](https://github.com/MortimerGoro/MGSwipeTableCell) 框架实现商品的左滑收藏、删除功能。
* **HQLShoppingCartHeaderView**：在 header view 上显示店铺标题，是 `UITableViewHeaderFooterView` 的子类对象，把店铺标题添加在 `UIButton` 上，实现点击店铺标题的跳转功能；
* **HQLShoppingCartSettleView**：购物车底部的结算视图。

Model:

* **HQLStore**：购物车商品模型类，iOS 中开源的模型框架有很多，这里使用 [Mantle](https://github.com/Mantle/Mantle) 框架设计模型类。当然你也可以使用 MJExtension 或者 YYModel 框架。
* **HQLShoppingCartManager**，该类遵守单例设计模式。它是购物车商品管理类，统一通过这个类来操作数据模型，以及提供一些像结算商品数量、选中商品的合计金额等数据。
* **shoppingCartGoods.plist** 文件，为便于演示，本项目下的商品数据是本地静态数据（保存在`shoppingCartGoods.plist` 文件中），生产环境中需要从服务器获取，你可以通过 `HQLShoppingCartFormat` 来负责网络请求、逻辑处理，以及结果的回调。

Proxy:

* **HQLShoppingCartProxy**：购物车列表视图控制器 DataSource、Delegate 的代理类，它遵守 `UITableViewDataSource` 和 `UITableViewDelegate` 协议。`UITableView` 的数据源和代理全部通过这个类来实现。
* **HQLShoppingCartFormat**：这个类主要负责网络请求、逻辑处理，以及结果的回调。



### 集成

本项目只是给出了一个通用的范例，具体到业务中还需要再做适配和调整。


## 如何贡献

欢迎任何贡献，有关如何参与到本项目的信息，请参见 [CONTRIBUTING](https://github.com/Andy0570/ShoppingCartDemo/blob/master/CONTRIBUTING.md)。


## 使用许可

本项目基于 [MIT](https://opensource.org/licenses/MIT) 许可协议，详情请参见 [LICENSE](https://github.com/Andy0570/ShoppingCartDemo/blob/master/LICENSE)。
