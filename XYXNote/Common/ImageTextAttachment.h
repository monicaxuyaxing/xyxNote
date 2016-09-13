//
//  ImageTextAttachment.h
//    玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextAttachment : NSTextAttachment
@property(assign, nonatomic) CGSize imageSize;  
- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size;
@end
