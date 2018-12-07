//
//  GQToast.m
//  AFNetworking
//
//  Created by 林国强 on 2018/12/7.
//

#import "GQToast.h"
#import <GQTool/GQLazyProperty.h>
#import <Masonry/Masonry.h>
#import <libextobjc/EXTScope.h>
#import <GQTool/UIColor+GQColor.h>


@interface GQToast()


@end

@implementation GQToast

+ (void)showToastWithText:(NSString *)text {
    static GQToast *toast;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [GQToast new];
    });
    toast.toastLabel.text = text;
    [toast showToast];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    if (self) {
        [self addSubview:self.toastBgView];
        [self.toastBgView addSubview:self.toastLabel];


        [self.toastBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-(50.f + 17.f));

            make.height.mas_equalTo(36.f);
        }];

        [self.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.toastBgView).insets(UIEdgeInsetsMake(12, 15, 12, 15));
        }];


    }
    return self;
}

- (void)showToast {
    @weakify(self)
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.toastBgView.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        @strongify(self)
        self.toastBgView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:1.f options:UIViewAnimationOptionTransitionNone animations:^{
            @strongify(self)
            self.toastBgView.alpha = 0;
        } completion:^(BOOL finished) {
            @strongify(self)
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - priavte

GQLazyPropertyWithInit(UILabel, toastLabel, {
    _toastLabel.textColor = [UIColor whiteColor];
    _toastLabel.font = [UIFont systemFontOfSize:12.f];
    _toastLabel.textAlignment = NSTextAlignmentCenter;
})

GQLazyPropertyWithInit(UIView, toastBgView, {
    _toastBgView.backgroundColor = [UIColor gq_colorWithHex:0x232425];
    _toastBgView.layer.cornerRadius = 18.f;
    _toastBgView.clipsToBounds = YES;
})

@end
