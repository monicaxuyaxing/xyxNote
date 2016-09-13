//
//  ImageTextAttachment.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.//

#import "ImageTextAttachment.h"

@implementation ImageTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
        return CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    
   
}
- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
