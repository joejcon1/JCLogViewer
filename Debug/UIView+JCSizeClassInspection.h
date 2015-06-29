//
//  UIViewController+JCSizeClassInspection.h
//  Reckoner
//
//  Created by Joe Conway on 26/04/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import UIKit;

@interface UIView (JCSizeClassInspection)

- (BOOL)isRegularHorizontal;
- (BOOL)isCompactHorizontal;
- (BOOL)isRegularVertical;
- (BOOL)isCompactVertical;

@end
