//
//  xyxShareButton.m
//  玩记
//
//  Created by monica on 16/7/20.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "xyxShareButton.h"

@implementation xyxShareButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleY = contentRect.size.height *0.8;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    
    CGFloat imageH = contentRect.size.height * 0.75;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}





@end
