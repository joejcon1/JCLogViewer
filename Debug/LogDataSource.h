//
//  LogDataSource.h
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

@import Foundation;
@import UIKit;
@class JCLogViewController;


@protocol LogDataSourceDelegate <NSObject>


- (void)dataDidChange;
- (void)dataDidChangeAtIndexPaths:(NSIndexSet * __nonnull)indexSet;

@end

@interface LogDataSource : NSObject<UICollectionViewDataSource>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, weak) id<LogDataSourceDelegate> delegate;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFileAtURL:(NSURL *)url viewController:(JCLogViewController *)vc NS_DESIGNATED_INITIALIZER;
- (UICollectionView *)instanceOfCollectionFromFactory;
- (void)levelSelectorChanged:(UISegmentedControl *)seg;
- (void)setAudiobooksFilterEnabled:(UIBarButtonItem *)barButtonItem;
NS_ASSUME_NONNULL_END


@end
