//
//  GQNavigationBar.m
//  GQCommonView
//
//  Created by 幸.😳 on 2018/12/1.
//

#import "GQNavigationBar.h"
#import <Masonry/Masonry.h>
#import <GQTool/UIColor+GQColor.h>

@interface GQNavigationBar()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation GQNavigationBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgView];
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.leftButton];
        [self.contentView addSubview:self.rightButton];
        [self.contentView addSubview:self.navBarTitleLabel];
        [self.contentView addSubview:self.navBarTitleImageView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.f);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12.f);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.navBarTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [self.navBarTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.mas_equalTo(44.f);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(44.f);
        }];
    }
    return self;
}

#pragma mark - set & get

- (UIImageView *)bgView {
    if(!_bgView) {
        _bgView = [UIImageView new];
    }
    return _bgView;
}

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIImageView *)navBarTitleImageView {
    if(!_navBarTitleImageView) {
        _navBarTitleImageView = [UIImageView new];
    }
    return _navBarTitleImageView;
}


- (UIButton *)leftButton {
    if(!_leftButton) {
        _leftButton = [UIButton new];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if(!_rightButton) {
        _rightButton = [UIButton new];
    }
    return _rightButton;
}

- (UILabel *)navBarTitleLabel {
    if(!_navBarTitleLabel) {
        _navBarTitleLabel = [UILabel new];
    }
    return _navBarTitleLabel;
}

@end
