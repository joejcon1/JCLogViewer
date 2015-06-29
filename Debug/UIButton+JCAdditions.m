//
//  UIButton+JCAdditions.m
//  Reckoner
//
//  Created by Joe Conway on 11/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "UIButton+JCAdditions.h"

@implementation UIButton (JCAdditions)

+ (UIButton *)standardButton
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    btn.contentScaleFactor = 1.0f;
    return btn;
}

@end
