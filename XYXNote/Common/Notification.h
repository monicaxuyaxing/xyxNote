//
//  Notification.h
//  玩记
//
//  Created by monica on 16/7/27.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
+ (instancetype)sharedNotification;
-(void)registerLocalNotification:(NSInteger)alertTime WithalertBody:(NSString *)alertbody AnduserDict:(NSString *)dictstr;

- (void)cancelLocalNotificationWithValue:(NSString *)value;
@end
