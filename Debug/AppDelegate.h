//
//  AppDelegate.h
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import UIKit;
#import <CocoaLumberjack/CocoaLumberjack.h>

#define UNUSED __attribute__ ((unused))
#define SelectorString(propName)    NSStringFromSelector(@selector(propName))

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) NSDictionary *launchOptions;
@property (nonatomic, strong) NSURL *fileURL;

@end

