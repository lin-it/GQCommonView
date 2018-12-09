//
//  GQInfinitelyRefreshFooter.m
//  cutisan
//
//  Created by 林国强 on 2018/12/7.
//  Copyright © 2018 林国强. All rights reserved.
//

#import "GQInfinitelyRefreshFooter.h"
#import <Masonry/Masonry.h>
#import <GQTool/UIColor+GQColor.h>


static CGFloat GQInfinitelyRefreshFooterStartRefreshOffset = 0.f;

@interface GQInfinitelyLoadingView : UIView
@property(nonatomic, strong) UILabel *loadingLabel;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, copy) NSString *loadingText;
@end

@interface GQInfinitelyNoMoreView : UIView
@property(nonatomic, strong) UILabel *noMoreLabel;
@property(nonatomic, strong) UIView *leftLine;
@property(nonatomic, strong) UIView *rightLine;

@property(nonatomic, copy) NSString *noMoreText;
@end


@interface GQInfinitelyRefreshFooter ()
@property (nonatomic, strong) UILabel *idleLabel;
@property (nonatomic, strong) GQInfinitelyLoadingView *loadingView;
@property (nonatomic, strong) GQInfinitelyNoMoreView *noMoreView;

@property (nonatomic, copy) NSString *noMoreText;
@end

@implementation GQInfinitelyRefreshFooter


+ (instancetype)footerWithNoMoreText:(NSString *)noMoreText refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    GQInfinitelyRefreshFooter *footer = [super footerWithRefreshingBlock:refreshingBlock];
    footer.noMoreText = noMoreText;
    footer.noMoreView.noMoreText = noMoreText;
    return footer;
}

+ (void) setGlobleStartRefreshOffset:(CGFloat)offset {
    if (offset > 0) {
        GQInfinitelyRefreshFooterStartRefreshOffset = offset;
    }
}

- (void) prepare {
    [super prepare];

    CGFloat finalOffset = GQInfinitelyRefreshFooterStartRefreshOffset;
    if (finalOffset <= 0) {
        finalOffset = [UIScreen mainScreen].bounds.size.height;
    }
    self.startRefreshOffset = finalOffset;
    [self addSubview:self.idleLabel];
    [self addSubview:self.loadingView];
    [self addSubview:self.noMoreView];

    self.clipsToBounds = YES;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    if (newSuperview) { // 新的父控件
        if (!self.hidden) {
            self.scrollView.mj_insetB += self.mj_h;
        }

        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    } else { // 被移除了
        if (!self.hidden) {
            self.scrollView.mj_insetB -= self.mj_h;
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];

    // 设置位置
    self.mj_y = self.scrollView.mj_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];

    if (self.state != MJRefreshStateIdle || self.mj_y == 0) return;

    if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + _scrollView.mj_insetB - self.mj_h - MAX(self.startRefreshOffset, 0.f)) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;

            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];

    if (self.state != MJRefreshStateIdle) return;

    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  // 不够一个屏幕
            if (_scrollView.mj_offsetY >= -_scrollView.mj_insetT) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState

    if (state == MJRefreshStateRefreshing) {
        [self executeRefreshingCallback];
    } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        if (MJRefreshStateRefreshing == oldState) {
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }
    }

    self.idleLabel.hidden = state != MJRefreshStateIdle;
    self.loadingView.hidden = state != MJRefreshStateRefreshing;
    self.noMoreView.hidden = state != MJRefreshStateNoMoreData;

    // 高度变化，处理scrollView.mj_insetB
    CGFloat preInsetB = self.scrollView.mj_insetB;
    preInsetB -= self.mj_h;
    if (state == MJRefreshStateNoMoreData) {
        self.mj_h = self.noMoreView.frame.size.height;
    } else {
        self.mj_h = self.idleLabel.frame.size.height;
    }
    preInsetB += self.mj_h;
    if (preInsetB != self.scrollView.mj_insetB) {
        self.scrollView.mj_insetB = preInsetB;
    }
}

- (void)setHidden:(BOOL)hidden {
    BOOL lastHidden = self.isHidden;

    [super setHidden:hidden];

    // 保存之前只的contentOffset
    CGPoint preContentOffset = self.scrollView.contentOffset;
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;

        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;

        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    }
    self.scrollView.contentOffset = preContentOffset;
}

- (void)configNoMoreView:(void(^)(UIView *noMoreView))block {
    for (UIView *v in self.noMoreView.subviews) {
        [v removeFromSuperview];
    }
    !block ?: block(self.noMoreView);
    CGFloat fittingHeight = [self.noMoreView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (fittingHeight > 0) {
        [self.noMoreView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(fittingHeight));
            make.center.width.equalTo(self);
        }];
    }
}

#pragma mark - setters & getters

- (void) setIdleText:(NSString *)idleText {
    _idleText = idleText;
    self.idleLabel.text = idleText;
}

- (void) setRefreshingText:(NSString *)refreshingText {
    _refreshingText = refreshingText;
    self.loadingView.loadingText = refreshingText;
}

- (UILabel *)idleLabel {
    if (!_idleLabel) {
        _idleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.mj_h)];
        _idleLabel.text = self.idleText ?: @"";
        _idleLabel.font = [UIFont systemFontOfSize:12];
        _idleLabel.textColor = [UIColor gq_colorWithHex:0xb2b2b2];
        _idleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _idleLabel;
}

- (GQInfinitelyLoadingView *)loadingView {
    if (!_loadingView) {
        CGFloat width = (self.mj_w == 0 ? [UIScreen mainScreen].bounds.size.width : self.mj_w);
        _loadingView = [[GQInfinitelyLoadingView alloc] initWithFrame:CGRectMake(0, 0, width, self.mj_h)];
    }
    return _loadingView;
}

- (GQInfinitelyNoMoreView *)noMoreView {
    if (!_noMoreView) {
        CGFloat width = (self.mj_w == 0 ? [UIScreen mainScreen].bounds.size.width : self.mj_w);
        _noMoreView = [[GQInfinitelyNoMoreView alloc] initWithFrame:CGRectMake(0, 0, width, self.mj_h)];
    }
    return _noMoreView;
}

@end



@implementation GQInfinitelyLoadingView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _loadingLabel = [UILabel new];
        _loadingLabel.text = @"加载中...";
        _loadingLabel.font = [UIFont systemFontOfSize:12];
        _loadingLabel.textColor = [UIColor gq_colorWithHex:0xb2b2b2];
        [self addSubview:_loadingLabel];

        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activityIndicatorView];

        [_activityIndicatorView startAnimating];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxLoadingLabelWidth = ceilf([UIScreen mainScreen].bounds.size.width * 0.7f);
    CGFloat textWidth = MIN(ceilf([self.loadingLabel sizeThatFits:CGSizeMake(maxLoadingLabelWidth, 12)].width), maxLoadingLabelWidth);
    self.loadingLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - textWidth)/2.f,
                                         (CGRectGetHeight(self.bounds)-12.f)/2.f,
                                         textWidth, 12.f);
    self.activityIndicatorView.mj_x = CGRectGetMinX(self.loadingLabel.frame)-40.f;
    self.activityIndicatorView.mj_y = (CGRectGetHeight(self.bounds)-20.f)/2.f;
}

- (void) setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
    self.loadingLabel.text = loadingText;
    [self setNeedsLayout];
}
@end

@implementation GQInfinitelyNoMoreView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _noMoreLabel = [UILabel new];
        _noMoreLabel.backgroundColor = [UIColor clearColor];
        _noMoreLabel.text = @"没有啦";
        _noMoreLabel.font = [UIFont systemFontOfSize:12];
        _noMoreLabel.textColor = [UIColor gq_colorWithHex:0xb2b2b2];
        _noMoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_noMoreLabel];

        _leftLine = [UIView new];
        _leftLine.backgroundColor = [UIColor gq_colorWithHex:0xe4e4e4];
        [self addSubview:_leftLine];

        _rightLine = [UIView new];
        _rightLine.backgroundColor = [UIColor gq_colorWithHex:0xe4e4e4];
        [self addSubview:_rightLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxLabelWidth = ceilf([UIScreen mainScreen].bounds.size.width * 0.7f);
    CGFloat textWidth = MIN(ceilf([self.noMoreLabel sizeThatFits:CGSizeMake(maxLabelWidth, 12)].width), maxLabelWidth);
    self.noMoreLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - textWidth)/2.f,
                                        (CGRectGetHeight(self.bounds)-12.f)/2.f,
                                        textWidth, 12.f);
    self.leftLine.frame = CGRectMake(12.f,
                                     CGRectGetHeight(self.bounds)/2.f,
                                     CGRectGetMinX(self.noMoreLabel.frame)-24.f,
                                     0.5f);
    self.rightLine.frame = CGRectMake(CGRectGetMaxX(self.noMoreLabel.frame) + 12.f,
                                      CGRectGetHeight(self.bounds)/2.f,
                                      CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.noMoreLabel.frame) - 24.f,
                                      0.5f);
}


- (void) setNoMoreText:(NSString *)noMoreText {
    _noMoreText = noMoreText;
    self.noMoreLabel.text = noMoreText;
    [self setNeedsLayout];
}
@end
