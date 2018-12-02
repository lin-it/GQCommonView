//
//  GQTabBar.h
//  AFNetworking
//
//  Created by 幸.😳 on 2018/12/1.
//

#import <UIKit/UIKit.h>

@interface GQTabBar : UIView

- (void)configWithList:(NSArray<NSDictionary *> *)list;

- (instancetype)initWithList:(NSArray<NSDictionary *> *)list;

@property (nonatomic, assign) NSInteger selectIdx;

@property (nonatomic, copy) void(^selectIdxBlock)(NSInteger idx);

@end
