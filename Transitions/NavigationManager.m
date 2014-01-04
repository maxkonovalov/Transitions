//
//  NavigationManager.m
//  Transitions
//
//  Created by Max Konovalov on 4.01.14.
//  Copyright (c) 2014 max. All rights reserved.
//

#import "NavigationManager.h"
#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "ViewControllerC.h"
#import "ABTransition.h"
#import "BATransition.h"

@interface NavigationManager () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (strong, nonatomic) UIPanGestureRecognizer *interactiveGestureRecognizer;
@end

@implementation NavigationManager

- (void)awakeFromNib
{
    self.interactiveGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTransitionGesture:)];
    self.interactiveGestureRecognizer.delegate = self;
    [self.navigationController.view addGestureRecognizer:self.interactiveGestureRecognizer];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    switch (operation)
    {
        case UINavigationControllerOperationPush:
        {
            if ([fromVC isKindOfClass:[ViewControllerA class]] && [toVC isKindOfClass:[ViewControllerB class]])
                return [ABTransition new];
            break;
        }
            
        case UINavigationControllerOperationPop:
        {
            if ([fromVC isKindOfClass:[ViewControllerB class]] && [toVC isKindOfClass:[ViewControllerA class]])
                return [BATransition new];
            break;
        }
            
        default:
            break;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactiveTransition;
}

#pragma mark - UIGestureRecognizer

- (void)handleTransitionGesture:(UIPanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:recognizer.view].y / recognizer.view.frame.size.height;
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            [self.interactiveTransition updateInteractiveTransition:progress];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.3)
                [self.interactiveTransition finishInteractiveTransition];
            else
                [self.interactiveTransition cancelInteractiveTransition];
            self.interactiveTransition = nil;
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController.transitionCoordinator isAnimated])
        return NO;
    
    if (self.navigationController.viewControllers.count < 2)
        return NO;
    
    UIViewController *fromVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    UIViewController *toVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
    
    if ([fromVC isKindOfClass:[ViewControllerB class]] && [toVC isKindOfClass:[ViewControllerA class]])
    {
        if (gestureRecognizer == self.interactiveGestureRecognizer)
            return YES;
    }
    else if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer)
    {
        return YES;
    }
    
    return NO;
}

@end
