/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTLog.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;
  
//  jsCodeLocation = [NSURL URLWithString:@"http://192.168.1.123:8081/index.bundle?platform=ios&dev=true"];

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"TestApp"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  // 接入个推
  [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
  // 注册远程通知
  [self registerRemoteNotification];
  
  return YES;
}

#pragma mark ---
#pragma mark --- Getui Action ---
// 注册远程通知
- (void)registerRemoteNotification{
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
      if (!error) {
        RCTLog(@"request authorization succeeded!");
      }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
  } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  } else {
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                   UIRemoteNotificationTypeSound |
                                                                   UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
  }
}

// 远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
  NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
  RCTLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
  
  // [ GTSdk ]：向个推服务器注册deviceToken
  [GeTuiSdk registerDeviceToken:token];
}

/// APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
// APP已经接收到“远程”通知(推送) - 透传推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
  // [ GTSdk ]：将收到的APNs信息传给个推统计
  [GeTuiSdk handleRemoteNotification:userInfo];
  
  // 控制台打印接收APNs信息
  RCTLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
  
  [[NSNotificationCenter defaultCenter]postNotificationName:GT_DID_RECEIVE_REMOTE_NOTIFICATION object:@{@"type":@"apns",@"userInfo":userInfo}];
  
  completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10中收到推送消息
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
  
  RCTLog(@"willPresentNotification：%@", notification.request.content.userInfo);
  [[NSNotificationCenter defaultCenter]postNotificationName:GT_DID_RECEIVE_REMOTE_NOTIFICATION object:@{@"type":@"apns",@"userInfo":notification.request.content.userInfo}];
  
  // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
  completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  
  RCTLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
  
  // [ GTSdk ]：将收到的APNs信息传给个推统计
  [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
  [[NSNotificationCenter defaultCenter]postNotificationName:GT_DID_CLICK_NOTIFICATION object:response.notification.request.content.userInfo];
  
  completionHandler();
}
#endif

#pragma mark --- GeTuiSdkDelegate ---
// SDK启动成功返回cid
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
  // [4-EXT-1]: 个推SDK已注册，返回clientId
  [[NSNotificationCenter defaultCenter]postNotificationName:GT_DID_REGISTE_CLIENTID object:clientId];
  RCTLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
}
// SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error {
  // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
  RCTLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}
// SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
  // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
  [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
  
  // 数据转换
  NSString *payloadMsg = nil;
  if (payloadData) {
    payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
  }
  
  // 控制台打印日志
  NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
  RCTLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
  NSDictionary *userInfo = @{@"taskId":taskId,@"msgId":msgId,@"payloadMsg":payloadMsg,@"offLine":offLine?@"YES":@"NO"};
  [[NSNotificationCenter defaultCenter]postNotificationName:GT_DID_RECEIVE_REMOTE_NOTIFICATION object:@{@"type":@"payload",@"userInfo":userInfo}];
}
// SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
  // 发送上行消息结果反馈
  NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
  RCTLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}
// SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
  // 通知SDK运行状态
  RCTLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}
// SDK设置推送模式回调
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
  if (error) {
    RCTLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
    return;
  }
  
  RCTLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}

#pragma mark
@end
