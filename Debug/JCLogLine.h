//
//  JCLogLine.h
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, JCLogLevel) {
    JCLogLevelVerbose,
    JCLogLevelDebug,
    JCLogLevelInfo,
    JCLogLevelWarn,
    JCLogLevelError,
    JCLogLevelFatal
};

@interface JCLogLine : NSObject

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) JCLogLevel logLevel;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *logText;

@end
