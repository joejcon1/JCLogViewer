//
//  UIColor+JCAdditions.h
//  Reckoner
//
//  Created by Joe Conway on 05/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import UIKit;

@interface UIImage (JCAdditions)

+ (UIImage *)imageNamed:(NSString *)name withColorMask:(UIColor *)mask;
- (UIColor *)primaryDominantColor;
- (UIColor *)secondaryDominantColor;
+ (UIImage *)imageWithColor:(UIColor *)color ofSize:(CGSize)size;

@end
