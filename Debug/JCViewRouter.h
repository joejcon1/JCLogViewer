//
//  APViewRouter.h
//  AudioPlayer
//
//  Created by Joe Conway on 04/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface JCViewRouter : NSObject


+ (instancetype)theRouter;


#pragma mark - Routing
#
@property (nonatomic, strong) UIWindow *mainWindow;
- (void)displayInitialLaunchScreen;
- (void)displayMainApplication;


@end
