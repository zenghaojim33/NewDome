//
//  AppDelegate.m
//  NewDome
//
//  Created by Anson on 15/6/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialSinaHandler.h>
#import <UMSocialQQHandler.h>


@interface AppDelegate ()

@end


#define UmengAppkey @"54a350bffd98c51f0900012d"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, [UIFont fontWithName:@"Arial-Black" size:20.0f],NSFontAttributeName,nil];
    [[UINavigationBar appearance]setTitleTextAttributes:dic];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearance].barStyle = UIStatusBarStyleDefault;
    
    
    //推送
    [self initPush:application];
    
    //修改状态栏
    [self changeStatusBar:application];
    
    //友盟分享
    [self setUMSocia];
    
    
    
    return YES;
}

-(void)setUMSocia
{
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //    //打开调试log的开关
   // [UMSocialData openLog:YES];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx2f715ea59b2f5af0" appSecret:@"f3d78a77261c4280a9938f74fdcc82e7" url:@"http://www.dome123.com"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://api.weibo.com/oauth2/default.html"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1104266642" appKey:@"TbOZRpjCrV9OPVYN" url:@"http://www.dome123.com"];
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    

    
}
#pragma mark 新浪微博回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    NSLog(@"新浪微博回调：%@",url.description);
    return  [UMSocialSnsService handleOpenURL:url];
    
}


#pragma mark 推送
-(void)initPush:(UIApplication *)application
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    
    else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
}
#pragma mark 修改状态栏
-(void)changeStatusBar:(UIApplication*)application
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
    }
}
#pragma mark 判断当前设备
// #import "sys/utsname.h"


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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
