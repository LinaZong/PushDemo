//
//  AppDelegate.m
//  APNSDemo1
//
//  Created by 宗丽娜 on 16/4/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import "ViewController.h"
@interface AppDelegate ()
{
    ViewController  * _viewController;
}
@end

@implementation AppDelegate

/**IOS 小白  初次接触推送，自己研究一天，集成简单推送，只为自己方便做个学习笔记，忘大神指教********/

            /*****此代码包括APNS和极光两种推送的集成demo*******、
  极光的消息和通知
消息 是极光推送来的  不走苹果的APNS
    通知 是要服务器提交到极光  机极光提交到苹果APNS    然后推送到 你手机上
    APP在后台时 是收不到 极光推送来的消息  但是任何时候都可以收到通知
    APNS
    收到通知 后  如果APP 没有在前台  可以通过通知中心 查看通知  且 APP会有角标小圆点   如果在前台  收到通知 后 如果你没有做弹窗 那么不会有任何提示

****/




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [[UIApplication sharedApplication]registerForRemoteNotifications];
    UIViewController * view =[[UIViewController alloc] init];
    
    [self.window setRootViewController:view];
    [self.window makeKeyAndVisible];
    [self gotoJGPush:launchOptions];
    
    
    return YES;
}

-(void)gotoJGPush:(NSDictionary *)launchOptions{
   
    //广告位
    //    NSString * advertisingId =[[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];

    //启动SDK launchOptions启动参数
    /****
     launchOptions是一个NSDictionary类型的对象，存储的是程序启动的原因。
     
     用户(点击icon)直接启动程序，launchOptions内无数据；
     其它程序通过openURL:方式启动，则可以通过键UIApplicationLaunchOptionsURLKey来获取传递过来的url
     由本地通知启动，则可以通过键UIApplicationLaunchOptionsLocalNotificationKey来获取本地通知对象(UILocalNotification)
     由远程通知启动，则可以通过键UIApplicationLaunchOptionsRemoteNotificationKey来获取远程通知信息(NSDictionary)
     ****/
    //channel发布渠道  实例化JPUSHService
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:nil apsForProduction:YES advertisingIdentifier:nil];

    
    //注册APNS的推送类型，告诉系统接收push 来的信息
    //自定义类型的通知
//    NSSet * set = [NSSet setWithArray:@[@"kJPFNetworkDidSetupNotification",@"kJPFNetworkDidCloseNotification",@"kJPFNetworkDidRegisterNotification",@"kJPFNetworkDidLoginNotification"]];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //客户端设置（用户输入）
        
        /**这个参数的目的是用来注册一组和通知关联起来的button的事件。
         这个categories由一系列的 UIUserNotificationCategory组成。每个UIUserNotificationCategory对象包含你的app用来响应本地或者远程通知的信息。每一个对象的title作为通知上每一个button的title展示给用户。当用户点击了某一个button，系统将会调用应用内的回调函数application:handleActionWithIdentifier:forRemoteNotification:completionHandler:或者application:handleActionWithIdentifier:forLocalNotification:completionHandler:。
         **/
        NSMutableSet * categories = [NSMutableSet set];
        UIMutableUserNotificationCategory * category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"indetifier";
        UIMutableUserNotificationAction * action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"test2";
        action.title = @"test";
        action.activationMode = UIUserNotificationActivationModeBackground;
        action.authenticationRequired = YES;
        //YES显示为红色，NO显示为蓝色
        action.destructive = NO;
        
        NSArray *actions = @[ action ];
        
        [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
        
        [categories addObject:category];
        
        /**设置带有快速回复内容的通知
         
         UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc]init];
         replyAction.title = @"Reply";
         replyAction.identifier = @"comment-reply";
         replyAction.activationMode = UIUserNotificationActivationModeBackground;
         replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
         
         UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
         category.identifier = @"reply";
         [category setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];

         **/
        
        
        
        //注册推送
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
    }else{
        
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert) categories:nil];
    }
    
    

}

//****************************APNS**********************//

//APNS   得到令牌
//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
//    NSString * devStr = [NSString stringWithFormat:@"%@",deviceToken];
//    NSLog(@"动态令牌%@",devStr);
//}
//-(void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(nonnull NSString *)userActivityType error:(nonnull NSError *)error{
//    //push错误
//    NSLog(@"失贝");
//    
//}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //收到的push消息，userInfo：push里服务器传递的相关信息，这个信息是由公司服务器自己设定的。可以在这里处理一些逻辑
//}
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    //它是类里自带的方法,这个方法得说下，很多人都不知道有什么用，它一般在整个应用程序加载时执行，挂起进入后也会执行，所以很多时候都会使用到
//    [self confirmationWasHidden:nil];
//}

////调用psh，请求获取动态令牌
//- (void) confirmationWasHidden: (NSNotification *) notification
//{
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}


//*********************************************************************************//
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//APP进入后台，设置通知角标
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

//APP即将进入后台的时候设置通知的角标，显示通知的个数
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    
    //取消所有的本地通知
    [application cancelAllLocalNotifications];
    
    
}
//获取动态的deviceToken
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    //把获取的deviceToken发给极光
    NSLog(@"获取的token   %@",deviceToken);
    _viewController.deviceToken =  [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    [JPUSHService  registerDeviceToken:deviceToken];
}
// 极光处理借到的推送信息  APP 接收到通知的信息对通信信息进行处理
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo{
    
    _viewController.userInfo =  [[NSDictionary alloc] initWithDictionary:userInfo copyItems:YES];
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"%@",userInfo);
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"didReceiveUse = %@",userInfo);
        completionHandler(UIBackgroundFetchResultNewData);
    
    [JPUSHService handleRemoteNotification:userInfo];

}



//注册APNS 失败的调用的方法，失败原因
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    NSLog(@"did fail To Register For Remote Notifications With Error :%@",error);
}


/**
 
 回调的方法iOS9使用了两个新的回调方法来处理点击按钮的事件:
 
 **/
//处理本地
-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler{
    
}


-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler{
    
    /**设置带有快速回复内容的通知
     **/
    if ([identifier isEqualToString:@"comment-reply"]) {
        NSString *response = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        //对输入的文字作处理
    }
    completionHandler();
    
}



//使用UILocalNotification
//-(void)setLocationNotification{
////    CLLocationCoordinate2D coordinate2D;
//
//    coordinate2D.latitude = 100.0;
//    coordinate2D.longitude = 100.0;
//    CLRegion *currentRegion =
//    [[CLCircularRegion alloc] initWithCenter:coordinate2D
//                                      radius:CLLocationDistanceMax
//                                  identifier:@"test"];
//    
//    [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:120]
//                          alertBody:@"test ios8 notification"
//                              badge:0
//                        alertAction:@"取消"
//                      identifierKey:@"1"
//                           userInfo:nil
//                          soundName:nil
//                             region:currentRegion
//                 regionTriggersOnce:YES
//                           category:@"test"];
//}

/*******极光推送各种坑的解决
 
 在配置证书的时，开发证书发布证书，还有设置的APS_FOR_PRODUCTION 以及实例化JPUSHService setupWithOption:launchOptions appKey:appKey channel:nil apsForProduction:YES advertisingIdentifier:nil的方法里面的apsForProduction:YES一定要一致
 
 同时在测试时code signing identity 一定要是主账号
 provisioning profile  为推送证书，要与设置的推送的环境相同，如何是在开发环境，一定要使用开发证书
 ******/

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
