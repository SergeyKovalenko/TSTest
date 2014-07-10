//
//  TSTTransitionViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/9/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTTransitionViewController.h"
static const NSTimeInterval TSTAnimationDuration = 0.3;

@interface TSTTransitionViewController ()
@property (nonatomic, strong) NSMutableDictionary *viewControllers;
@property (nonatomic, readwrite) UIView *containerView;
@property (nonatomic, readwrite) UIViewController *contentController;

@end

@interface TSTTransitionSegue : UIStoryboardSegue

@end

@implementation TSTTransitionSegue

- (void)perform {
    UIViewController *destinationViewController = self.destinationViewController;
    TSTTransitionViewController *sourceViewController = self.sourceViewController;
    [sourceViewController registerViewController:destinationViewController
                         forInterfaceOrientationMask:destinationViewController.supportedInterfaceOrientations];
}

@end

@implementation TSTTransitionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewControllers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView {
//    self.extendedLayoutIncludesOpaqueBars = YES;
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
    
    _containerView = [[UIView alloc] initWithFrame:view.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"TSTTransitionSegue" sender:nil];
    [self performSegueWithIdentifier:@"TSTTransitionSegue2" sender:nil];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateContentForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] animated:animated];
}


- (void)transitionToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController  withOptions:(UIViewAnimationOptions)options animated:(BOOL)animated
{
    UIViewAnimationOptions animationOptions = options |
    UIViewAnimationOptionLayoutSubviews |
    UIViewAnimationOptionAllowAnimatedContent |
    UIViewAnimationOptionOverrideInheritedOptions;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    toViewController.view.frame = self.containerView.bounds;
    toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    fromViewController.view.frame = self.containerView.bounds;
    fromViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    void(^completion)(BOOL finished) = ^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
    };
    
    if (animated)
    {
        if (fromViewController)
        {
            [UIView transitionFromView:fromViewController.view
                                toView:toViewController.view
                              duration:TSTAnimationDuration
                               options:animationOptions
                            completion:completion];
            
        }
        else
        {
            
            [UIView transitionWithView:self.containerView
                              duration:TSTAnimationDuration
                               options:animationOptions
                            animations:^{
                                [self.containerView addSubview:toViewController.view];
                            } completion:completion];
        }
    }
    else
    {
        [fromViewController.view removeFromSuperview];
        [self.containerView addSubview:toViewController.view];
        completion(YES);
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger supportedInterfaceOrientationsMask = 0;
    for (NSNumber *orientation in [self.viewControllers allKeys]) {
        supportedInterfaceOrientationsMask |= 1 << orientation.unsignedIntegerValue;
    }
    return supportedInterfaceOrientationsMask;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
    [self updateContentForInterfaceOrientation:toInterfaceOrientation animated:YES];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

}

- (void)updateContentForInterfaceOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated
{
    UIViewController *controller = [self registeredViewControllerForInterfaceOrientation:orientation];
    if (controller && self.contentController != controller) {
        [self transitionToViewController:controller fromViewController:self.contentController withOptions:UIViewAnimationOptionTransitionCrossDissolve animated:YES];
        self.contentController = controller;
    }
}

- (void)registerViewController:(UIViewController *)viewController forInterfaceOrientationMask:(NSUInteger)orientationMask
{
    if ((orientationMask & UIInterfaceOrientationMaskPortrait) == UIInterfaceOrientationMaskPortrait) {
        self.viewControllers[@(UIInterfaceOrientationPortrait)] = viewController;
    }
    
    if ((orientationMask & UIInterfaceOrientationMaskLandscapeLeft) == UIInterfaceOrientationMaskLandscapeLeft) {
        self.viewControllers[@(UIInterfaceOrientationLandscapeLeft)] = viewController;
    }
    
    if ((orientationMask & UIInterfaceOrientationMaskLandscapeRight) == UIInterfaceOrientationMaskLandscapeRight) {
        self.viewControllers[@(UIInterfaceOrientationLandscapeRight)] = viewController;
    }
    
    if ((orientationMask & UIInterfaceOrientationMaskPortraitUpsideDown) == UIInterfaceOrientationMaskPortraitUpsideDown) {
        self.viewControllers[@(UIInterfaceOrientationPortraitUpsideDown)] = viewController;
    }
}

- (UIViewController *)registeredViewControllerForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return self.viewControllers[@(orientation)];
}

@end
