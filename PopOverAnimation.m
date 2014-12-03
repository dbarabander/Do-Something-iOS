//
//  PopOverAnimation.m
//  FISDoSomething
//
//  Created by Ismail Mustafa on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "PopOverAnimation.h"
#define viewControllerScale 0.97

@implementation PopOverAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.75;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    __block CGFloat width = [UIScreen mainScreen].bounds.size.width;
    __block CGFloat height = [UIScreen mainScreen].bounds.size.height;
    __block CGFloat widthBorder = width - (width * viewControllerScale);
    __block CGFloat heightBorder = height - (height * viewControllerScale);
    
    if (!self.reverse) {
        [[transitionContext containerView] addSubview:toViewController.view];
        
        toViewController.view.frame = CGRectMake(widthBorder, height*1.2, width - widthBorder*2, height - heightBorder*2);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.0 options:0 animations:^{
            
            toViewController.view.frame = CGRectMake(widthBorder, heightBorder, width - widthBorder*2, height - heightBorder*2);
            fromViewController.view.alpha = 0.3;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.0 options:0 animations:^{
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = [UIScreen mainScreen].bounds.size.height;
            
            toViewController.view.frame = CGRectMake(0, 0, width, height);
            fromViewController.view.frame = CGRectMake(widthBorder, height*1.2, width - widthBorder*2, height - heightBorder*2);
            toViewController.view.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
