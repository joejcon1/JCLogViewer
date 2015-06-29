//
//  UIColor+JCAdditions.m
//  Reckoner
//
//  Created by Joe Conway on 05/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "UIImage+JCAdditions.h"

@implementation UIImage (JCAdditions)

+ (UIImage *)imageNamed:(NSString *)name withColorMask:(UIColor *)mask
{
    UIImage *img = [UIImage imageNamed:name];
    return [self filledImageFrom:img withColor:mask];
}

+ (UIImage *)filledImageFrom:(UIImage *)source withColor:(UIColor *)color
{
    
    // begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}


- (UIColor *)primaryDominantColor
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)(kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big));
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGFloat red = rgba[0];
    CGFloat green = rgba[1];
    CGFloat blue = rgba[2];
    CGFloat alpha = rgba[3];

    CGFloat multiplier = 255.0f;
    CGFloat alphaMultiplier = 1.0f;
    if(alpha > 0) {
        multiplier = alpha;
    }
    else {
        alphaMultiplier = 255;
    }
    red *= multiplier;
    green *= multiplier;
    blue *= multiplier;
    alpha *= alphaMultiplier;

    return [UIColor colorWithRed: red
                           green: green
                            blue: blue
                           alpha: alpha];
}

- (UIColor *)secondaryDominantColor
{
    return [UIColor whiteColor];
}

+ (UIImage *)imageWithColor:(UIColor *)color ofSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    rect.size = size;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
