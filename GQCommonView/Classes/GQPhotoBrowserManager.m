//
//  GQPhotoBrowserManager.m
//  AFNetworking
//
//  Created by 林国强 on 2018/12/7.
//
#import <GQTool/GQLazyProperty.h>
#import "GQPhotoBrowserManager.h"

@implementation GQPercentDrivenInteractiveTransition

@end


@implementation GQPhotoBrowserPresentAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController<GQPhotoBrowserManagerDelegate> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    UIView *sourceView = nil;
    if ([toVC respondsToSelector:@selector(viewAtIdxBlock)] && [toVC respondsToSelector:@selector(currentIndex)]) {
        sourceView = toVC.viewAtIdxBlock(toVC.currentIndex);
    }

    CGRect frame = [UIScreen mainScreen].bounds;
    if ([toVC respondsToSelector:@selector(toFrameAtIdxBlock)] && [toVC respondsToSelector:@selector(currentIndex)]) {
        frame = toVC.toFrameAtIdxBlock(toVC.currentIndex);
    }

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

@implementation GQPhotoBrowserDismissalAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

}
@end

@interface GQPhotoBrowserManager()

@property (nonatomic, weak) UIViewController *bindViewController;

@end

@implementation GQPhotoBrowserManager

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)bindToViewController:(UIViewController*)viewController {
    self.bindViewController = viewController;
    viewController.transitioningDelegate = self;
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//    [viewController.view addGestureRecognizer:pan];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissalAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}


#pragma mark - set & get

GQLazyPropertyWithInit(GQPercentDrivenInteractiveTransition, interactiveTransition, {

})

GQLazyPropertyWithInit(GQPhotoBrowserPresentAnimation, presentAnimation, {

})

GQLazyPropertyWithInit(GQPhotoBrowserDismissalAnimation, dismissalAnimation, {

})

@end
