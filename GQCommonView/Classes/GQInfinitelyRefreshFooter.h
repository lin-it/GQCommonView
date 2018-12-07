//
//  GQInfinitelyRefreshFooter.h
//  cutisan
//
//  Created by 林国强 on 2018/12/7.
//  Copyright © 2018 林国强. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQInfinitelyRefreshFooter : MJRefreshFooter
+ (instancetype)footerWithNoMoreText:(NSString *)noMoreText refreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@property (nonatomic, copy) NSString *idleText;
@property (nonatomic, copy) NSString *refreshingText;

// 默认值是一屏幕高度, 可通过设置为0来禁用提前加载下一页功能
@property(nonatomic, assign) CGFloat startRefreshOffset;

// 设置全局的offset
+ (void) setGlobleStartRefreshOffset:(CGFloat)offset;

// 个性化配置 NoMoreView，如果有高度的变化，直接设置noMoreView的高度即可(或者设置noMoreView的约束)
/*
 *  例子：
 [self.mj_footer configNoMoreView:^(UIView *noMoreView) {
 UIView *v = [UIView new];
 [noMoreView addSubview:v];
 [v mas_makeConstraints:^(MASConstraintMaker *make) {
 make.center.width.equalTo(noMoreView);
 make.height.equalTo(@15.f);
 // 1. 通过修改noMoreView内容的约束
 make.top.equalTo(@40);
 make.bottom.equalTo(@-40);
 }];
 // 2. 通过直接修改height
 noMoreView.mj_h = 100.f;

 // 3. 通过修改noMoreView本身的约束
 [noMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.height.equalTo(@100);
 make.center.width.equalTo(noMoreView.superview);
 }];
 }];
 */
- (void)configNoMoreView:(void(^)(UIView *noMoreView))block;
@end

NS_ASSUME_NONNULL_END
