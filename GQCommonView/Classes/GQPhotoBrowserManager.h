//
//  GQPhotoBrowserManager.h
//  AFNetworking
//
//  Created by 林国强 on 2018/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GQPhotoBrowserManagerDelegate <NSObject>

@property (nonatomic, copy) UIView *(^viewAtIdxBlock)(NSInteger idx);
@property (nonatomic, copy) CGRect(^toFrameAtIdxBlock)(NSInteger idx);


@property (nonatomic, readonly) NSUInteger currentIndex;

@end


@interface GQPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@end

@interface GQPhotoBrowserPresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface GQPhotoBrowserDismissalAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@end

@interface GQPhotoBrowserManager : NSObject<UIViewControllerTransitioningDelegate>

@property(nonatomic, strong) GQPercentDrivenInteractiveTransition *interactiveTransition;
@property(nonatomic, strong) GQPhotoBrowserPresentAnimation *presentAnimation;
@property(nonatomic, strong) GQPhotoBrowserDismissalAnimation *dismissalAnimation;

- (void)bindToViewController:(UIViewController<GQPhotoBrowserManagerDelegate> *)viewController;

@end

NS_ASSUME_NONNULL_END
