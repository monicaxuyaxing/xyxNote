//
//  xyxCollectionViewCell.m
//  玩记
//
//  Created by monica on 16/7/14.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "xyxCollectionViewCell.h"
#import "xyxGuideViewManager.h"
#import "UIImage+SLImage.h"

@implementation xyxCollectionViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
   
    self.imageView = [[UIImageView alloc]initWithFrame:kxyxGuideViewBounds];

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.hidden = YES;
    [button setFrame:CGRectMake(0, 0, 200, 44)];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:5];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:1.0f];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    self.button = button;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    
    [self.button setCenter:CGPointMake(kxyxGuideViewBounds.size.width / 2, kxyxGuideViewBounds.size.height - 90)];
}

@end

