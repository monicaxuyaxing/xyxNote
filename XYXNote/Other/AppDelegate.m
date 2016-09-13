//
//  AppDelegate.m
//  玩记
//
//  Created by monica on 16/6/29.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "AppDelegate.h"
#import "Colours.h"
#import "NotepadViewController.h"
#import "ListViewController.h"
#import "NoteManager.h"
#import "NoteModel.h"
#import "iflyMSC/IFlyMSC.h"
#import "UMSocial.h"
#import "Constants.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "DatePickerController.h"
#import "AlertTableViewController.h"
#import "Notification.h"





@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[self addInitFileIfNeeded];
   
    self.window.backgroundColor = [UIColor whiteColor];
    
    //a.初始化一个tabBar控制器
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器
    self.window.rootViewController=tb;
    
    ListViewController *controller1 = [[ListViewController alloc] init];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:controller1];
    
    navigationController1.tabBarItem.title = @"日记";
  
    navigationController1.tabBarItem.image = [[UIImage imageNamed:@"news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [navigationController1.navigationBar setTintColor:[UIColor black25PercentColor]];
    [navigationController1.navigationBar setBarTintColor:[UIColor easterPinkColor]];
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               nil];

    [navigationController1.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    


    AlertTableViewController *controller2 = [[AlertTableViewController alloc] init];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:controller2];
    navigationController2.tabBarItem.title = @"提醒事项";
    navigationController2.tabBarItem.image = [[UIImage imageNamed:@"bird"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navigationController2.navigationBar setTintColor:[UIColor black25PercentColor]];
    [navigationController2.navigationBar setBarTintColor:[UIColor easterPinkColor]];
    [navigationController2.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    


     tb.viewControllers=@[navigationController1,navigationController2];

    
    [self.window makeKeyAndVisible];
    
       //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMAppId];
    [UMSocialWechatHandler setWXAppId:kWeixinAppID appSecret:@"78645bc0402f4736f422e53b44d3423f" url:Url];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:Url];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppID
                                              secret:kSinaAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil];
        
        [application registerUserNotificationSettings:setting];
        
   
}


    
       return YES;
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未完成事项"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    
    
       // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
   [[Notification sharedNotification] cancelLocalNotificationWithValue:@"key"];}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //取消徽章
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
