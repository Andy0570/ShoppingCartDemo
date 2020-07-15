//
//  HQLShoppingCartSettleView.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShoppingCartSettleView.h"

// Framework
#import <BEMCheckBox.h>
#import <Chameleon.h>
#import <Masonry.h>
#import <YYKit.h>

@interface HQLShoppingCartSettleView () <BEMCheckBoxDelegate>

@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UILabel *checkBoxLabel;
@property (nonatomic, strong) UIButton *settleButton; // 结算按钮
@property (nonatomic, strong) UILabel *totalCountLabel; // 商品数量
@property (nonatomic, strong) UILabel *totalPriceLabel; // 合计金额

@end

@implementation HQLShoppingCartSettleView

#pragma mark - View life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.checkBox];
    [self addSubview:self.checkBoxLabel];
    [self addSubview:self.settleButton];
    [self addSubview:self.totalCountLabel];
    [self addSubview:self.totalPriceLabel];
    
    // 全选按钮
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(17);
        make.left.mas_equalTo(self).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    // 全选按钮静态标题
    [self.checkBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.checkBox);
    }];
    
    // 商品数量
    [self.totalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBoxLabel.mas_right).with.offset(8);
        make.centerY.mas_equalTo(self.checkBox);
    }];
    
    // 合计金额
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.totalCountLabel.mas_right).with.offset(5);
        make.centerY.mas_equalTo(self.checkBox);
        make.right.mas_equalTo(self.settleButton.mas_left).with.offset(-4);
    }];
    
    // 结算按钮
    [self.settleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(7);
        make.right.mas_equalTo(self).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(96, 40));
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
        // _checkBox.enabled = NO;
        _checkBox.minimumTouchSize = CGSizeMake(25, 25);
        _checkBox.delegate = self;
    }
    return _checkBox;
}

- (UILabel *)checkBoxLabel {
    if (!_checkBoxLabel) {
        _checkBoxLabel = [[UILabel alloc] init];
        _checkBoxLabel.text = @"全选";
        _checkBoxLabel.font = [UIFont systemFontOfSize:13];
        _checkBoxLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    }
    return _checkBoxLabel;
}

- (UIButton *)settleButton {
    if (!_settleButton) {
        _settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 正常标题
        NSDictionary *normalAttr = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"结算"
                                                                    attributes:normalAttr];
        [_settleButton setAttributedTitle:normalTitle
                                 forState:UIControlStateNormal];
        // 高亮标题
        NSDictionary *highlightAttr = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
            NSForegroundColorAttributeName:HexColor(@"#ff3b30")
        };
        NSAttributedString *highlightTitle = [[NSAttributedString alloc] initWithString:@"结算" attributes:highlightAttr];
        [_settleButton setAttributedTitle:highlightTitle
                                 forState:UIControlStateHighlighted];
        
        // 设置背景图片
        [_settleButton setBackgroundImage:[UIImage imageWithColor:HexColor(@"#ff3b30")]
                                 forState:UIControlStateNormal];
        [_settleButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                 forState:UIControlStateHighlighted];
        [_settleButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]]
                                 forState:UIControlStateDisabled];
        
        // 切圆角
        _settleButton.layer.cornerRadius = 18;
        _settleButton.layer.masksToBounds = YES;
        
        // Target-Action
        [_settleButton addTarget:self action:@selector(settleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _settleButton.enabled = NO;
    }
    return _settleButton;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.font = [UIFont systemFontOfSize:14];
        _totalPriceLabel.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _totalPriceLabel.text = @"合计: ￥0";
        
        // 设置缩小文本字体以适应 UILabel 固定宽度
        // 当 Label 的宽度小于完整字符串宽度时，缩小文本字体以适应宽度
        _totalPriceLabel.adjustsFontSizeToFitWidth = YES;
        // 字体最小缩放比例
        _totalPriceLabel.minimumScaleFactor = 0.6;
    }
    return _totalPriceLabel;
}

- (UILabel *)totalCountLabel {
    if (!_totalCountLabel) {
        _totalCountLabel = [[UILabel alloc] init];
        _totalCountLabel.font = [UIFont systemFontOfSize:14];
        _totalCountLabel.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1];
        _totalCountLabel.text = @"共 0 件商品";
        
        // 设置缩小文本字体以适应 UILabel 固定宽度
        // 当 Label 的宽度小于完整字符串宽度时，缩小文本字体以适应宽度
        _totalCountLabel.adjustsFontSizeToFitWidth = YES;
        // 字体最小缩放比例
        _totalCountLabel.minimumScaleFactor = 0.6;
    }
    return _totalCountLabel;
}

#pragma mark - Actions

- (void)settleButtonAction:(id)sender {
    if (self.settleGoodsBlock) {
        self.settleGoodsBlock();
    }
}

#pragma mark - Public

- (void)updateWithTotalPrice:(float)totalPrice
                      amount:(NSInteger)amount
      allSelectedButtonState:(BOOL)isAllSelected
         settleButtonEnabled:(BOOL)isEnabled
{
    self.checkBox.on = isAllSelected;
    self.settleButton.enabled = isEnabled;
    
    // 商品数量
    self.totalCountLabel.text = [NSString stringWithFormat:@"共 %ld 件商品",(long)amount];
    
    // 合计金额
    self.totalPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.0f", totalPrice];
    [self renderWithTotalPrice:[NSString stringWithFormat:@"￥%.0f", totalPrice]];
}

// 渲染合计金额字符串
- (void)renderWithTotalPrice:(NSString *)totalPrice {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.totalPriceLabel.text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:210/255.0 green:50/255.0 blue:50/255.0 alpha:1]} range:[self.totalPriceLabel.text rangeOfString:totalPrice]];
    self.totalPriceLabel.attributedText = attributedString;
    self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
}

#pragma mark - <BEMCheckBoxDelegate>

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (self.allSelectedBlock) {
        self.allSelectedBlock(checkBox.on);
    }
}

@end
