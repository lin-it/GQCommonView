//
//  GQPhotoBrowserManager.m
//  AFNetworking
//
//  Created by 林国强 on 2018/12/7.
//
#import <GQTool/GQLazyProperty.h>
#import "GQPhotoBrowserManager.h"
#import <libextobjc/EXTScope.h>

UIImage *GQPhotoBrowerImageFromView(UIView *v);

UIImage *GQPhotoBrowerImageFromView(UIView *v) {
    if ([v isKindOfClass:[UIImageView class]]) {
        UIImageView *img = (UIImageView *)v;
        return img.image;
    }
    UIGraphicsBeginImageContextWithOptions(v.bounds.size, YES, 0);
    if (!v.layer.backgroundColor || CGColorEqualToColor(v.layer.backgroundColor, [UIColor clearColor].CGColor)) {
        v.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@interface __GQPhotoAnimatingImageView : UIImageView
@property(nonatomic, strong) CAShapeLayer *maskLayer;
@property(nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, copy) void(^animationBlock)(void);
@property (nonatomic, copy) void(^complete)(void);

@property (nonatomic, assign) CGRect starMaskFrame;
@property (nonatomic, assign) CGRect endMaskFrame;

@property (nonatomic, assign) CGRect starFrame;
@property (nonatomic, assign) CGRect endFrame;

@property (nonatomic, assign) CGFloat duration;


- (void)showAnimation;
- (void)showAnimationWithMaskLayer:(BOOL)maskLayer;
- (void)showMaskLayerWithTime:(CGFloat)duration;

@end


@implementation GQPercentDrivenInteractiveTransition

@end


@implementation GQPhotoBrowserPresentAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController<GQPhotoBrowserManagerDelegate> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
//    [containerView addSubview:toVC.view];

    UIView *sourceView = nil;
    if ([toVC respondsToSelector:@selector(viewAtIdxBlock)] && [toVC respondsToSelector:@selector(currentIndex)]) {
        sourceView = toVC.viewAtIdxBlock(toVC.currentIndex);
    }

    CGRect initialImageViewFrame = [sourceView.superview convertRect:sourceView.frame
                                                              toView:[[UIApplication sharedApplication].delegate window]];

    CGRect finallyFrame = [UIScreen mainScreen].bounds;
    if ([toVC respondsToSelector:@selector(toFrameAtIdxBlock)] && [toVC respondsToSelector:@selector(currentIndex)]) {
        finallyFrame = toVC.toFrameAtIdxBlock(toVC.currentIndex);
    }
     __GQPhotoAnimatingImageView *animatingImageView = [[__GQPhotoAnimatingImageView alloc] initWithFrame:initialImageViewFrame];
    CGRect starMaskRect = CGRectMake(0, 0, initialImageViewFrame.size.width, initialImageViewFrame.size.height);
    CGRect starFrame = initialImageViewFrame;

    UIImage *image = GQPhotoBrowerImageFromView(sourceView);
    CGSize imageSize = image.size;
    CGFloat w = 0;
    CGFloat h = 0;
    if (imageSize.width < imageSize.height) {
        CGFloat r = imageSize.width / initialImageViewFrame.size.width;
        h = imageSize.height / r;
        w = initialImageViewFrame.size.width;
    } else {
        CGFloat r = imageSize.height / initialImageViewFrame.size.height;
        w = imageSize.width / r;
        h = initialImageViewFrame.size.height;
    }
    CGPoint center = animatingImageView.center;
    starFrame = CGRectMake(center.x - w/2.f, center.y - h/2.f, w, h);
    animatingImageView.frame = starFrame;
    starMaskRect = CGRectMake((w - initialImageViewFrame.size.width)/2.f, (h - initialImageViewFrame.size.height)/2.f, initialImageViewFrame.size.width, initialImageViewFrame.size.height);

    [containerView addSubview:animatingImageView];
//    toVC.view.alpha = 0.f;

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    animatingImageView.duration = duration;
    animatingImageView.starMaskFrame = starMaskRect;
    animatingImageView.starFrame = starFrame;
    animatingImageView.endFrame = finallyFrame;
    animatingImageView.endMaskFrame = CGRectMake(0, 0, finallyFrame.size.width, finallyFrame.size.height);
    @weakify(toVC,animatingImageView,transitionContext,sourceView)
    animatingImageView.animationBlock = ^{
        @strongify(toVC)
//        toVC.view.alpha = 1.f;
    };
    animatingImageView.complete = ^{
        @strongify(toVC,animatingImageView,transitionContext,sourceView)
        [transitionContext completeTransition:YES];
        sourceView.hidden = NO;
//        [toVC setBigImgViewHide:NO];
//        [toVC reloadReplaceView];
        [animatingImageView removeFromSuperview];
    };
    [animatingImageView showAnimation];
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

@implementation __GQPhotoAnimatingImageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.maskLayer = [CAShapeLayer layer];
        self.maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.mask = self.maskLayer;
        self.maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return self;
}

- (void)showMaskLayerWithTime:(CGFloat)duration {
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation.fromValue = (__bridge id)([UIBezierPath bezierPathWithRect:self.starMaskFrame].CGPath);
    maskAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithRect:CGRectMake(self.endMaskFrame.origin.x + self.insets.left, self.endMaskFrame.origin.y + self.insets.top, self.endMaskFrame.size.width - self.insets.left - self.insets.right, self.endMaskFrame.size.height - self.insets.bottom - self.insets.top)].CGPath);
    maskAnimation.duration = duration;
    maskAnimation.removedOnCompletion = NO;
    maskAnimation.fillMode = kCAFillModeForwards;
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.maskLayer addAnimation:maskAnimation forKey:@"maskAnimation"];
}

- (void)showAnimationWithMaskLayer:(BOOL)maskLayer {

    if (maskLayer && !CGRectEqualToRect(CGRectZero, self.endMaskFrame)) {
        [self showMaskLayerWithTime:self.duration];
    }
    [UIView animateWithDuration:self.duration animations:^{
        if (!CGRectEqualToRect(CGRectZero, self.endFrame)) {
            self.frame = self.endFrame;
        } else {
            self.frame = CGRectMake(self.starFrame.origin.x, self.endFrame.origin.y + CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        }
        if (self.animationBlock) {
            self.animationBlock();
        }
    } completion:^(BOOL finished) {
        if (self.complete) {
            self.complete();
        }
    }];
}

- (void)showAnimation {
    [self showAnimationWithMaskLayer:YES];

}
@end
