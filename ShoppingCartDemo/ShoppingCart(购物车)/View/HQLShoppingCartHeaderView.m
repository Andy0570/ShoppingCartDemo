//
//  HQLShoppingCartHeaderView.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShoppingCartHeaderView.h"

// Frameworks
#import <BEMCheckBox.h>
#import <Chameleon.h>
#import <Masonry.h>

// 12+18+12 = 42
const CGFloat HQLShoppingCartHeaderViewHeight = 42.0f;
NSString *const HQLShoppingCartHeaderViewReuserIdentifier = @"HQLShoppingCartHeaderView";

@interface HQLShoppingCartHeaderView () <BEMCheckBoxDelegate>

@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIImageView *arrorImageView;

@end

@implementation HQLShoppingCartHeaderView

#pragma mark - View life cycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.checkBox];
    [self.contentView addSubview:self.shopImageView];
    [self.contentView addSubview:self.titleButton];
    [self.contentView addSubview:self.arrorImageView];
    
    // 单选按钮
    CGFloat padding = 12.0f;
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(padding);
        make.left.mas_equalTo(self.contentView).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.bottom.mas_equalTo(self.contentView).with.offset(-padding);
    }];
    
    [self.shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(padding);
        make.centerY.mas_equalTo(self.checkBox);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    // 店铺名称按钮
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shopImageView.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.checkBox);
    }];
    
    // 店铺按钮右侧的箭头图片
    [self.arrorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleButton.mas_right).with.offset(padding);
        make.centerY.mas_equalTo(self.checkBox);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}

#pragma mark - Custom Accessors

- (BEMCheckBox *)checkBox {
    if (!_checkBox) {
        _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        // 外观属性
        _checkBox.lineWidth = 1.0;
        // 颜色样式
        _checkBox.tintColor    = [UIColor lightGrayColor];
        _checkBox.onTintColor  = HexColor(@"#FF3B30");
        _checkBox.onFillColor  = HexColor(@"#FF3B30");
        _checkBox.onCheckColor = [UIColor whiteColor];
        // 动画样式
        _checkBox.onAnimationType  = BEMAnimationTypeBounce;
        _checkBox.offAnimationType = BEMAnimationTypeBounce;
        _checkBox.animationDuration = 0.1;
        _checkBox.minimumTouchSize = CGSizeMake(25, 25);
        _checkBox.delegate = self;
    }
    return _checkBox;
}

- (UIImageView *)shopImageView {
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _shopImageView.image = [UIImage imageNamed:@"shop_light"]; // 18*18
        _shopImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shopImageView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton addTarget:self action:@selector(titleButtionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIImageView *)arrorImageView {
    if (!_arrorImageView) {
        _arrorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrorImageView.image = [UIImage imageNamed:@"button_arror"]; // 12*12
        _arrorImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrorImageView;
}

#pragma mark - Actions

// 点击店铺标题，跳转到店铺主页
- (void)titleButtionAction:(id)sender {
    if (self.titleButtonActionBlock) {
        self.titleButtonActionBlock();
    }
}

#pragma mark - Public

- (void)updateWithStoreName:(NSString *)storeName selectedState:(BOOL)isSelected {
    // 设置按钮标题、颜色、字体
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0f]
    };
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:storeName attributes:attributes];
    [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
    
    // 店铺选中状态
    [self.checkBox setOn:isSelected];
}

#pragma mark - <BEMCheckBoxDelegate>

// 选中店铺下所有商品
- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if (self.selectButtonActionBlock) {
        self.selectButtonActionBlock(checkBox.on);
    }
}

@end
