//
//  JCLogViewController.h
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import UIKit;

@interface JCLogViewController : UIViewController <UICollectionViewDelegate>


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFileAtURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;
- (CGSize)estimatedCellSize;

@end
