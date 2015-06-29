//
//  LogDataSource.m
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "LogDataSource.h"
#import <Masonry/Masonry.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "UIColor+JCAdditions.h"

#import "AppDelegate.h"
#import "JCLogViewController.h"
#import "UILabel+JCAdditions.h"
#import "JCLogCell.h"
#import "JCLogLine.h"

static NSString *const JCkLogCellReuseIdentifier = @"JCkLogCellReuseIdentifier";

/*-------------------------*/
@interface JCLogViewFlowLayout : UICollectionViewFlowLayout
@end
/*-------------------------*/
@interface LogDataSource ()
@property (nonatomic, weak) JCLogViewController *vc;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *allLines;
@property (nonatomic, strong) NSArray *linesAtCurrentLevel;
@property (nonatomic, strong) NSMutableArray *appliedFilterPredicates;
@property (nonatomic, assign) JCLogLevel currentLevel;

@property (nonatomic, strong) NSPredicate *audiobooksFilterPredicate;

@end
/*-------------------------*/



@implementation LogDataSource
@synthesize vc = _vc;
@synthesize url = _url;
@synthesize delegate = _delegate;
@synthesize allLines = _allLines;
@synthesize linesAtCurrentLevel = _linesAtCurrentLevel;
@synthesize currentLevel = _currentLevel;
@synthesize appliedFilterPredicates = _appliedFilterPredicates;


- (instancetype)initWithFileAtURL:(NSURL *)url viewController:(JCLogViewController *)vc
{
    self = [super init];
    if (self) {
        _vc = vc;
        _url = url;
        _appliedFilterPredicates = [NSMutableArray array];
        [self _loadFile];

    }
    return self;
}

- (void)_loadFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homeDirectory = [paths objectAtIndex:0];
    
    homeDirectory = [homeDirectory stringByAppendingFormat:@"/debug.txt"];
    NSError *readError;
    NSError *copyError;
    NSError *deleteError;
    [[NSFileManager defaultManager] removeItemAtPath:homeDirectory
                                               error:&deleteError];
    [[NSFileManager defaultManager] copyItemAtPath:self.url.path
                                            toPath:homeDirectory
                                             error:&copyError];
    NSString *string = [NSString stringWithContentsOfFile:homeDirectory
                                                 encoding:NSUTF8StringEncoding
                                                    error:&readError];
    if (!string) {
        DDLogError(@"Error loading file %@ %@ %@", deleteError, copyError, readError);
    }
    NSArray *components = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *mutableLines = [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" M/dd/yy, H:mm:ss a"];
    for (NSString *lineString in components) {
        NSArray *lineComponents = [lineString componentsSeparatedByString:@"|"];
        if (lineComponents.count > 1) {
            JCLogLine *line = [[JCLogLine alloc] init];
            [mutableLines addObject:line];
            
            //LogLevel
            
            NSString *level = lineComponents[0];
            if ([level isEqual:@"E "]) {
                line.logLevel = JCLogLevelError;
            }
            else if ([level isEqual:@"W "]) {
                line.logLevel = JCLogLevelWarn;
            }
            else if ([level isEqual:@"I "]) {
                line.logLevel = JCLogLevelInfo;
            }
            else if ([level isEqual:@"D "]) {
                line.logLevel = JCLogLevelDebug;
            }
            else if ([level isEqual:@"V "]) {
                line.logLevel = JCLogLevelVerbose;
            }

            //Timestamp
            NSString *timeStamp = lineComponents[1];
            line.timestamp = [formatter dateFromString:timeStamp];
            
            //Text
            line.logText = lineComponents[2];
        } else {
            JCLogLine *line = mutableLines.lastObject;
            if (line) {
                line.logText = [line.logText stringByAppendingFormat:@"\n%@",lineString];
                [mutableLines replaceObjectAtIndex:(mutableLines.count-1) withObject:line];
            }
        }
    }
    self.allLines = [NSArray arrayWithArray:mutableLines];
    components = nil;
    mutableLines = nil;
    string = nil;
    [self reloadData];
}

- (void)reloadData
{
    /*
     Make the initial filter based on log level, it'll be faster to apply more complex predicates
     */
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.logLevel >= (%d-1)", self.currentLevel];
    self.linesAtCurrentLevel = [self.allLines filteredArrayUsingPredicate:pred];
    
    
    for (NSPredicate *predicate in self.appliedFilterPredicates) {
        if (self.linesAtCurrentLevel.count == 0) {
            continue;
        }
        
        self.linesAtCurrentLevel = [self.linesAtCurrentLevel filteredArrayUsingPredicate:predicate];
    }
    
    
    [self.delegate dataDidChange];
}

- (JCLogLine *)dataForIndex:(NSIndexPath *)index
{
    JCLogLine *line = self.linesAtCurrentLevel[index.row];
    return line;
}


#pragma mark - Filtering Predicates
#

- (NSPredicate *)audiobooksFilterPredicate
{
    if (!_audiobooksFilterPredicate) {
        NSPredicate *audiobooksPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([evaluatedObject isKindOfClass:[JCLogLine class]] == NO) {
                return NO;
            }
            JCLogLine *line = (JCLogLine *)evaluatedObject;
            BOOL isListenEvent = [line.logText rangeOfString:@"LISTEN: "].location != NSNotFound;
            
            BOOL isFWAENotification = [line.logText rangeOfString:@"FWAE"].location != NSNotFound;
            
            return (isListenEvent || isFWAENotification);
        }];
        _audiobooksFilterPredicate = audiobooksPredicate;
    }
    
    return _audiobooksFilterPredicate;
}

#pragma mark - Data Source
#

- (void)setCurrentLevel:(JCLogLevel)currentLevel
{
    if (currentLevel != _currentLevel) {
        _currentLevel = currentLevel;
        [self reloadData];
    }
}

#pragma mark - Configuration
#

- (Class)cellClass
{
    return [JCLogCell class];
}

- (void)_configureCell:(JCLogCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor backgroundColor];
    JCLogLine *n = [self dataForIndex:indexPath];
    [cell configureWithLogLine:n];
}

#pragma mark - Factories
#

- (UICollectionView *)instanceOfCollectionFromFactory
{
    JCLogViewFlowLayout *flowLayout = [[JCLogViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *ret = [[UICollectionView alloc] initWithFrame:self.vc.view.bounds
                                               collectionViewLayout:flowLayout];
    [ret registerClass:self.cellClass forCellWithReuseIdentifier:JCkLogCellReuseIdentifier];
    ret.dataSource = self;
    ret.delegate = self.vc;
    [self.vc.view addSubview:ret];
    
    ret.backgroundColor = [UIColor backgroundColor];
    [ret mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        make.top.equalTo(self.vc.view).with.offset(statusBarHeight);
        make.right.equalTo(self.vc.view);
        make.left.equalTo(self.vc.view);
        make.bottom.equalTo(self.vc.view);
    }];
    
    
    ret.tintColor = [UIColor blueColor];
    return ret;
}


#pragma mark - Log Level Switch
#


- (void)levelSelectorChanged:(UISegmentedControl *)seg
{
    JCLogLevel level = seg.selectedSegmentIndex;
    [self setCurrentLevel:level];
}

- (void)setAudiobooksFilterEnabled:(UIBarButtonItem *)barButtonItem
{
    NSPredicate *pred = [self audiobooksFilterPredicate];
    BOOL alreadyEnabled = [self.appliedFilterPredicates containsObject:pred];
    if (alreadyEnabled) {
        [self.appliedFilterPredicates removeObject:pred];
        [barButtonItem setTitle:@"📢"];
    } else {
        [self.appliedFilterPredicates addObject:pred];
        [barButtonItem setTitle:@"🔇"];
    }
    
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource
#


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.linesAtCurrentLevel.count-1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCLogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JCkLogCellReuseIdentifier
                                                                           forIndexPath:indexPath];
    if (!cell) {
        cell = [[[self cellClass] alloc] initWithReuseIdentifier:JCkLogCellReuseIdentifier];
    }
    [self _configureCell:cell forIndexPath:indexPath];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


@end



@implementation JCLogViewFlowLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end

