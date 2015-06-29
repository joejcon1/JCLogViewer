//
//  UILabel+JCAdditions.m
//  Reckoner
//
//  Created by Joe Conway on 11/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "UILabel+JCAdditions.h"

@implementation UILabel (JCAdditions)

+ (UILabel *)standardLabel
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    return lbl;
}


@end
