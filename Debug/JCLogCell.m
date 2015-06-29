//
//  JCLogCell.m
//  Debug
//
//  Created by Joe Conway on 27/06/2015.
//  Copyright (c) 2015 JoeConway. All rights reserved.
//

#import "JCLogCell.h"
#import "UILabel+JCAdditions.h"
#import "UIFont+JCAddditions.h"
#import "JCLogLine.h"
#import <Masonry/Masonry.h>


static NSDateFormatter * shortDateFormatter = nil;


@interface JCLogCell ()

@property (nonatomic, strong) UILabel *lblTime;
@property (nonatomic, strong) UILabel *lblText;
@end

@implementation JCLogCell
@synthesize lblTime = _lblTime;
@synthesize lblText = _lblText;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lblText = [UILabel standardLabel];
        _lblText.font = [UIFont systemFontOfSize:12];
        _lblText.numberOfLines = 0;
        _lblText.textAlignment = NSTextAlignmentLeft;
        _lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_lblText];
        
        _lblTime = [UILabel standardLabel];
        _lblTime.font = [UIFont systemFontOfSize:12];
        _lblTime.numberOfLines = 2;
        _lblTime.textAlignment = NSTextAlignmentCenter;
        _lblTime.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_lblTime];
        
        [self.contentView.layer setBorderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor];
        [self.contentView.layer setBorderWidth:0.5f];
        
        
        [_lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat margin = 5.0f;
            make.top.equalTo(self.contentView).with.offset(margin);
            make.left.equalTo(self.contentView).with.offset(margin);
            make.bottom.equalTo(self.contentView).with.offset(-margin);
            make.width.equalTo(@60);
        }];
        
        [_lblText mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat margin = 5.0f;
            make.top.equalTo(self.contentView).with.offset(margin);
            make.left.equalTo(self.lblTime.mas_right).with.offset(margin);
            make.right.equalTo(self.contentView).with.offset(-margin);
            make.bottom.equalTo(self.contentView).with.offset(-margin);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)configureWithLogLine:(JCLogLine *)line
{
    self.lblTime.text = [[[self class] JCSharedShortDateFormatter] stringFromDate:line.timestamp];
    [self.lblTime sizeToFit];
    self.lblText.text = line.logText;
    switch (line.logLevel) {
        case JCLogLevelVerbose:
        {
            self.lblText.textColor = [UIColor darkGrayColor];
            break;
        }
        case JCLogLevelDebug:
        {
            self.lblText.textColor = [UIColor greenColor];
            break;
        }
        case JCLogLevelInfo:
        {
            self.lblText.textColor = [UIColor colorWithRed:0.3 green:0.5 blue:1 alpha:1.0f];
            break;
        }
        case JCLogLevelWarn:
        {
            self.lblText.textColor = [UIColor orangeColor];
            break;
        }
        case JCLogLevelError:
        {
            self.lblText.textColor = [UIColor redColor];
            break;
        }
        case JCLogLevelFatal:
        {
            self.lblText.textColor = [UIColor redColor];
            break;
        }
    }
}


#pragma mark - AutoLayout
#

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    UICollectionViewLayoutAttributes *attr = layoutAttributes.copy;
//    CGRect newFrame = attr.frame;
//    CGFloat desiredHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
//    newFrame.size.height = desiredHeight;
//    attr.frame = newFrame;
//    
//    
//    self.frame = attr.frame;
//    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    
//    return attr;
//}

#pragma mark -
#


+ (NSDateFormatter *) JCSharedShortDateFormatter {
    
    @synchronized([NSDateFormatter class]){
        
        if( shortDateFormatter == nil){
            
            // Create new formatter for SHORT times (e.g. 12:00 pm)
            
            shortDateFormatter = [[NSDateFormatter alloc] init];
            [shortDateFormatter setDateFormat:@"dd/MM/yy H:mm:ss"];
        }
        
        return shortDateFormatter;
        
    }
    
    return nil;
}
@end
