//
//  APLaunchViewController.m
//  AudioPlayer
//
//  Created by Joe Conway on 04/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "JCLaunchViewController.h"
#import "JCLaunchView.h"
#import "JCViewRouter.h"
#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation JCLaunchViewController

#pragma mark - View Lifecycle
#

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCocoaLumberjack];
    [self preloadLogFile];
    [self setupObservers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    JCLaunchView *viewLaunch = [[JCLaunchView alloc] init];
    self.view = viewLaunch;

}
#pragma mark - Notifications
#


- (void)setupObservers
{
    
}


- (void)fetcherDidFinishFetching:(UNUSED NSNotification *)notification
{
    [self _finishedPerformingAppSetup];
}

#pragma mark - App Setup
#

- (void)preloadLogFile
{
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary *launchOptions = appdelegate.launchOptions;
    NSURL *fileURL = launchOptions[UIApplicationLaunchOptionsURLKey];
    if (fileURL) {
        DDLogWarn(@"Moving log file from URL into documents directory");
        NSError *copyError;
        NSURL *destinationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),fileURL.lastPathComponent]];
        BOOL success = [[NSFileManager defaultManager] copyItemAtURL:fileURL
                                                toURL:destinationURL
                                                error:&copyError];
        if (success) {
            DDLogDebug(@"Succesfully copied log file to documents directory at %@", destinationURL.absoluteString);
        } else {
            DDLogError(@"Failed to copy log file to documents directory %@", copyError);
        }
    } else{
        DDLogError(@"No file url provided, falling back to demo log file");
    }
    [[JCViewRouter theRouter] displayMainApplication];
}

- (void)setupCocoaLumberjack
{
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    
    
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(258, 51, 66)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(255, 114, 42)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(0,189,225)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:DDMakeColor(75, 213, 81)
                                     backgroundColor:nil
                                             forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithWhite:0.4f alpha:0.3f]
                                     backgroundColor:nil
                                             forFlag:DDLogFlagVerbose];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];

}


- (void)_finishedPerformingAppSetup
{
    [[JCViewRouter theRouter] displayMainApplication];
}

@end
