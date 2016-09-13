//
//  ListViewCell.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "ListViewCell.h"
#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "Constants.h"
#import "UIColor+CustomColor.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

static const CGFloat kCellHorizontalMargin = 4;
static const CGFloat kTitleMargin = 8;
static const CGFloat kVerticalMargin = 4;
static const CGFloat kLabelHeight = 15;

static const CGFloat kMaxTitleHeight = 100;


@interface ListViewCell ()

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation ListViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(kCellHorizontalMargin,kVerticalMargin,screenWidth - 2 * kCellHorizontalMargin,0)];
        
         _backView.layer.cornerRadius = 4.0f;
        _backView.layer.masksToBounds = YES;
        [self.contentView addSubview:_backView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleMargin, kTitleMargin, screenWidth - kTitleMargin * 2, 0)];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_titleLabel setNumberOfLines:0];
        [_backView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleMargin-2, kTitleMargin, screenWidth - kTitleMargin * 2, kLabelHeight)];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:10]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_backView addSubview:_timeLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)updateWithNote:(NoteModel *)note
{
    NSString *string = note.title;
    [_titleLabel setText:note.title];
        
    CGFloat titleHeight =[[self class] heightWithString:string
                                                  width:screenWidth - kTitleMargin * 2];
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.size.height = titleHeight;
    _titleLabel.frame = titleFrame;
    
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = kTitleMargin + titleHeight;
    _timeLabel.frame = timeFrame;
    
    CGRect bgFrame = _backView.frame;
    bgFrame.size.height = [[self class] heightWithNote:note] - kVerticalMargin * 2;
    _backView.frame = bgFrame;
    
    UIColor *bgColor = [UIColor randomColor];
    [_backView setBackgroundColor:bgColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [_timeLabel setText:[formatter stringFromDate:note.createdDate]];
}

+ (CGFloat)heightWithNote:(NoteModel *)note
{
    NSString *string = note.title;
    //对于整个CELL来说的高度和宽度,并非backgroundView

    CGFloat titleHeight = [[self class] heightWithString:string width:screenWidth-kCellHorizontalMargin * 2 - kTitleMargin * 2];
    
    
    return kTitleMargin + titleHeight + kLabelHeight + kTitleMargin + kVerticalMargin;
}

+ (CGFloat)heightWithString:(NSString *)string width:(CGFloat)width
{
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:17] };
    //CGFloat width =
    CGSize size = [string boundingRectWithSize:CGSizeMake(screenWidth -kCellHorizontalMargin * 2 - kTitleMargin * 2, kMaxTitleHeight)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil].size;
    

    return ceilf(size.height);
}

@end
