//
//  Notification.m
//  玩记
//
//  Created by monica on 16/7/27.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "Notification.h"
#import <UIKit/UIKit.h>

@implementation Notification
+ (instancetype)sharedNotification
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}
// 设置本地通知
-(void)registerLocalNotification:(NSInteger)alertTime WithalertBody:(NSString *)alertbody AnduserDict:(NSString *)dictstr{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 通知内容
    notification.alertBody = alertbody;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:dictstr forKey:@"key"];
    notification.userInfo = userDict;
    NSLog(@"UserDict = %@",userDict);
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
- (void)cancelLocalNotificationWithValue:(NSString *)value {
//     //获取所有本地通知数组
//    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
//    
//    for (UILocalNotification *notification in localNotifications) {
//        NSDictionary *userDict = notification.userInfo;
//        if (userDict) {
//            // 根据设置通知参数时指定的key来获取通知参数
//            NSString *info = userDict[key];
//            
//            // 如果找到需要取消的通知，则取消
//            if (info != nil) {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                break;
//            }
//        }
//    }
    
    // 获得 UIApplication
    
    UIApplication *app = [UIApplication sharedApplication];
    
    //获取本地推送数组
    
    NSArray *localArray = [app scheduledLocalNotifications];
    
    
    if (localArray) {
        
        for (UILocalNotification *noti in localArray) {
            
            NSDictionary *dict = noti.userInfo;
            
            if (dict) {
                
                NSString *inKey = [dict objectForKey:@"key"];
                
                if ([inKey isEqualToString:value]) {
                    
                    [app cancelLocalNotification:noti];
                    
                    break;

                    
                }
                
            }  
            
        }
    }
    
    
    
}




@end
