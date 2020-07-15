//
//  HQLShoppingCartCell.m
//  ShoppingCartDemo
//
//  Created by Qilin Hu on 2020/7/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLShoppingCartCell.h"

// Framework
#import <BEMCheckBox.h>
#import <Chameleon.h>
#import <Masonry.h>
#import <SDWebImage.h>
#import <JKCategories.h>
#import <PPNumberButton.h>

// Model
#import "HQLStore.h"

// 10+88+10 = 108
const CGFloat HQLShoppingCartCellHeight = 108;
NSString *const HQLShoppingCartCellReuserIdentifier = @"HQLShoppingCartCell";

@interface HQLShoppingCartCell () <BEMCheckBoxDelegate, PPNumberButtonDelegate>

@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *specificationLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) PPNumberButton *numberButton;

@end

@implementation HQLShoppingCartCell

#pragma mark - View life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.checkBox];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.specificationLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.numberButton];
    
    // 单选按钮
    CGFloat padding = 12.0f;
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 商品图片,Vertical: |-10-88-10-|
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(10);
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(padding);
        make.size.mas_equalTo(CGSizeMake(88, 88));
        make.bottom.mas_equalTo(self.contentView).with.offset(-10);
    }];
    
    // 商品名称
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(padding);
        make.left.mas_equalTo(self.goodsImageView.mas_right).with.offset(padding);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-padding);
    }];
    
    // 商品规格
    [self.specificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(6);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.nameLabel);
    }];
    
    // 商品价格
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.goodsImageView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    // 商品购买数量
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-padding);
        make.centerY.mas_equalTo(self.priceLabel);
        make.size.mas_equalTo(CGSizeMake(90, 22));
    }];
}

#pragma mark - Custom Accessors

- (BEMCheckBox *)checkBox {
    if (!_checkBox) {
        _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectZero];
        // 外观属性
        _checkBox.lineWidth = 1.0;
        // 颜色样式
        _checkBox.tintColor = [UIColor lightGrayColor];
        _checkBox.onTintColor = HexColor(@"#FF3B30");
        _checkBox.onFillColor = HexColor(@"#FF3B30");
        _checkBox.onCheckColor = [UIColor whiteColor];
        // 动画样式
        _checkBox.onAnimationType = BEMAnimationTypeBounce;
        _checkBox.offAnimationType = BEMAnimationTypeBounce;
        _checkBox.animationDuration = 0.1;
        _checkBox.minimumTouchSize = CGSizeMake(25, 25);
        _checkBox.delegate = self;
    }
    return _checkBox;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageView.image = [UIImage imageNamed:@"goods_placeholder"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel *)specificationLabel {
    if (!_specificationLabel) {
        _specificationLabel = [[UILabel alloc] init];
        _specificationLabel.font = [UIFont systemFontOfSize:12.0f];
        _specificationLabel.textColor = [UIColor grayColor];
    }
    return _specificationLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
    }
    return _priceLabel;
}

- (PPNumberButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectZero];
        _numberButton.backgroundColor = rgb(249, 249, 249);
        _numberButton.borderColor = [UIColor whiteColor];
        _numberButton.increaseTitle = @"＋";
        _numberButton.decreaseTitle = @"－";
        _numberButton.currentNumber = 1;
        _numberButton.editing = NO;
        _numberButton.delegate = self;
    }
    return _numberButton;
}

- (void)setGoods:(HQLGoods *)goods {
    _goods = goods;
    
    // 商品选中状态
    [self.checkBox setOn:goods.selectedState.boolValue];
    
    // 商品图片
    UIImage *placeHolderImage = [UIImage imageNamed:@"goods_placeholder"];
    if ([goods.imageURL.absoluteString jk_isValidUrl]) {
        [self.goodsImageView sd_setImageWithURL:goods.imageURL placeholderImage:placeHolderImage];
    } else {
        self.goodsImageView.image = placeHolderImage;
    }
    
    // 商品标题
    self.nameLabel.text = goods.goodsName;
    
    // 商品规格
    self.specificationLabel.text = goods.specification;
    
    // 商品价格
    self.priceLabel.attributedText = [self attributedStringOfGoodsPrice:goods.price.floatValue];
    
    // 商品数量
    self.numberButton.currentNumber = goods.quantity.intValue;
    self.numberButton.minValue = 1;
    self.numberButton.maxValue = goods.stock.intValue ? : 1;
}

#pragma mark - Private

- (NSAttributedString *)attributedStringOfGoodsPrice:(float)price {
    NSString *string = [NSString stringWithFormat:@"¥ %.2f",price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName:[UIColor redColor],
        NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]
    };
    [attributedString addAttributes:attributes1 range:NSMakeRange(0, 1)];
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName:[UIColor redColor],
        NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium]
    };
    [attributedString addAttributes:attributes2 range:NSMakeRange(2, string.length - 2)];
    
    return attributedString;
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <BEMCheckBoxDelegate>

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (self.selectGoodsBlock) {
        self.selectGoodsBlock(checkBox.on);
    }
}

#pragma mark - <PPNumberButtonDelegate>

- (void)pp_numberButton:(PPNumberButton *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus {
    if (self.updateGoodsQuantityBlock) {
        self.updateGoodsQuantityBlock(number);
    }
}

@end
