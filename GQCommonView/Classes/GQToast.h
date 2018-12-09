//
//  GQToast.h
//  AFNetworking
//
//  Created by 林国强 on 2018/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GQToast : UIView

@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) UIView *toastBgView;


+ (instancetype)showToastWithText:(NSString *)text;

+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
