//
//  UIViewController+JCSizeClassInspection.m
//  Reckoner
//
//  Created by Joe Conway on 26/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "UIView+JCSizeClassInspection.h"

@implementation UIView (JCSizeClassInspection)

- (BOOL)isRegularHorizontal
{
    UITraitCollection *traits = self.vc.traitCollection;
    return traits.horizontalSizeClass == UIUserInterfaceSizeClassRegular;
}

- (BOOL)isCompactHorizontal
{
    UITraitCollection *traits = self.vc.traitCollection;
    return traits.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
}


- (BOOL)isRegularVertical
{
    UITraitCollection *traits = self.vc.traitCollection;
    return traits.verticalSizeClass == UIUserInterfaceSizeClassRegular;
}

- (BOOL)isCompactVertical
{
    UITraitCollection *traits = self.vc.traitCollection;
    return traits.verticalSizeClass == UIUserInterfaceSizeClassCompact;
}

- (UIViewController *)vc
{
    return [self valueForKey:@"viewController"];
}

@end
