//
//  APViewRouter.m
//  AudioPlayer
//
//  Created by Joe Conway on 04/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "JCViewRouter.h"
#import "JCLaunchViewController.h"
#import "JCLogViewController.h"
#import "AppDelegate.h"

@interface JCViewRouter()

@end

@implementation JCViewRouter

@synthesize mainWindow = _mainWindow;

- (id)init
{
    self = [super init];
    if (self) {
        _mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

+ (instancetype)theRouter
{
    static JCViewRouter *mainRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainRouter = [[self alloc] init];
    });
    return mainRouter;
}

- (UIViewController *)launchView
{
    JCLaunchViewController *v = [[JCLaunchViewController alloc] init];
    return v;
}

- (void)displayInitialLaunchScreen
{
    [self _setRootViewController:[self launchView]];
}

- (void)displayMainApplication
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSURL *url = delegate.fileURL;
    if (url) {
        url = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"debug" ofType:@"txt"]];
        JCLogViewController *logViewer = [[JCLogViewController alloc] initWithFileAtURL:url];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewer];
        [self _setRootViewController:nav];
    }
    
}


#pragma mark - Routing
#

- (void)_setRootViewController:(UIViewController *)vc
{
    [self.mainWindow setRootViewController:vc];
    [self.mainWindow makeKeyAndVisible];
    
}

@end
