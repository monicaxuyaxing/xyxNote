//
//  UIColor+CustomColor.m
//  玩记
//
//  Created by monica on 16/7/1.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "UIColor+CustomColor.h"
#import "Colours.h"

@implementation UIColor (CustomColor)
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5];
    
}

+ (UIColor *)titleColor
{
    return [UIColor colorWithRed:255 green:182 blue:193 alpha:1.0];
}


+(UIColor *)datePickerColor{
    return [UIColor colorWithRed:233 green:166 blue:165 alpha:0.5];
}



@end
