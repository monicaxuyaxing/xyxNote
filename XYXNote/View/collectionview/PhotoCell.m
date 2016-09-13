//
//PhotoCell.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.//

#import "PhotoCell.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageButton = [[UIButton alloc] initWithFrame:self.contentView.bounds];
       
        [self.contentView addSubview:_imageButton];
    }
    
    return self;
}





@end
