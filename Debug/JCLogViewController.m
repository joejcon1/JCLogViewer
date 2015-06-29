//
//  JCLogViewController.m
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "JCLogViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"

#import "LogDataSource.h"
#import "JCLogLine.h"
#import "UIColor+JCAdditions.h"

@interface JCLogViewController ()<LogDataSourceDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LogDataSource *dataSource;

@end

@implementation JCLogViewController

@synthesize collectionView = _collectionView;
@synthesize dataSource = _dataSource;

- (instancetype)initWithFileAtURL:(NSURL *)url
{
    NSParameterAssert(url);
    
    self = [super init];
    if (self) {
        _dataSource = [[LogDataSource alloc] initWithFileAtURL:url viewController:self];
        _dataSource.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.collectionView = [self.dataSource instanceOfCollectionFromFactory];
    [self.collectionView setNeedsUpdateConstraints];
    [self.collectionView reloadData];
    [self _setupNavbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Toolbar
#
- (void)_setupNavbar
{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"A",@"V",@"D",@"I",@"W",@"E"]];
    [seg sizeToFit];
    seg.tintColor = [UIColor lightGrayColor];
    [seg setSelectedSegmentIndex:1];
    [seg addTarget:self.dataSource action:@selector(levelSelectorChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    UIBarButtonItem *btnAudiobooksFilter = [[UIBarButtonItem alloc] initWithTitle:@"📢" style:UIBarButtonItemStylePlain target:self.dataSource action:@selector(setAudiobooksFilterEnabled:)];
    [self.navigationItem setRightBarButtonItem:btnAudiobooksFilter];
    
    UIBarButtonItem *btnScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"👇"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(scrollToBottom)];
    UIBarButtonItem *btnScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"☝️"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(scrollToTop)];
    
    [self.navigationItem setLeftBarButtonItems:@[btnScrollToBottom, btnScrollToTop]];
}


- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)scrollToBottom
{
    NSInteger section = [self.collectionView numberOfSections] - 1;
    NSInteger item = [self.collectionView numberOfItemsInSection:section] - 1;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    if (lastIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:lastIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:YES];
    }
}

- (void)scrollToTop
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        [self.collectionView scrollToItemAtIndexPath:firstIndexPath
                                    atScrollPosition:UICollectionViewScrollPositionTop
                                            animated:YES];
    }
}

#pragma mark - DataSource Delegate
#

- (void)dataDidChange
{
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)dataDidChangeAtIndexPaths:(UNUSED NSIndexSet*)indexSet
{
    [self.collectionView reloadData];
    [self.collectionView.collectionViewLayout invalidateLayout];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).estimatedItemSize = [self estimatedCellSize];
}

#pragma mark - Flow Layout delegate
#
- (CGSize)estimatedCellSize
{
    UIEdgeInsets insets = [self edgeInsets];
    CGFloat width = CGRectGetWidth(self.view.frame) - (insets.left + insets.right);
    CGFloat height = 44.f;
    CGRect rect = CGRectMake(0, 0, width, height);
    rect = CGRectIntegral(rect);
    return rect.size;
}

- (UIEdgeInsets)edgeInsets
{
    CGFloat margin = 2.0f;
    return UIEdgeInsetsMake(2*margin, margin, margin, margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self estimatedCellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return [self edgeInsets];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}



@end
