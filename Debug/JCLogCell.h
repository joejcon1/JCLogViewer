//
//  JCLogCell.h
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import UIKit;
@class JCLogLine;

@interface JCLogCell : UICollectionViewCell

NS_ASSUME_NONNULL_BEGIN

- (void)configureWithLogLine:(JCLogLine *)line;

NS_ASSUME_NONNULL_END
@end
