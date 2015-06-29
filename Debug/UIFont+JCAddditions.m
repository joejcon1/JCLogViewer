//
//  UIFont+JCAddditions.m
//  Reckoner
//
//  Created by Joe Conway on 11/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "UIFont+JCAddditions.h"

@implementation UIFont (JCAddditions)


+ (UIFont *)regularFontOfSize:(NSInteger)size
{
    return [UIFont fontWithName:@"AppleSDGothicNeo" size:size];
}

+ (UIFont *)boldFontOfSize:(NSInteger)size
{
    return [UIFont fontWithName:@"Avenir-Heavy" size:size];
}

+ (UIFont *)italicFontOfSize:(NSInteger)size
{
    return [UIFont fontWithName:@"Avenir-BookOblique" size:size];
}

@end
