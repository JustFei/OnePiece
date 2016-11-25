//
//  AppDelegate.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "AppDelegate.h"
#import "OPMainViewController.h"
#import "LoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (ScreenHeight > 480) { // 这里以(iPhone4S)为准
        self.autoSizeScaleX = ScreenWidth/320;
        self.autoSizeScaleY = ScreenHeight/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    if (ScreenHeight > 568) { // 这里以(iPhone5S)为准
        self.autoSizeScaleX = ScreenWidth/375;
        self.autoSizeScaleY = ScreenHeight/667;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    if (ScreenHeight > 736) { // 这里以(iPhone5S)为准
        self.autoSizeScaleX = ScreenWidth/414;
        self.autoSizeScaleY = ScreenHeight/736;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    OPMainViewController *mainVC = [[OPMainViewController alloc] init];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self registSocialApp];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    
    
    return YES;
}


- (void)registSocialApp
{
    [ShareSDK registerApp:@"194fa5d1d46cc"
         activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                           @(SSDKPlatformTypeWechat),
                           @(SSDKPlatformTypeQQ),]
                onImport:^(SSDKPlatformType platformType) {
                    switch (platformType)
                    {
                        case SSDKPlatformTypeWechat:
                            [ShareSDKConnector connectWeChat:[WXApi class]];
                            break;
                        case SSDKPlatformTypeQQ:
                            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                            break;
                        case SSDKPlatformTypeSinaWeibo:
                            [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                            break;
                        default:
                            break;
                    }
                }
         onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:@"3203517801"
                                               appSecret:@"27a4d610927c6940137bdf7deb728841"
                                             redirectUri:@"http://www.sharesdk.cn"
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:@"1105769829"
                                          appKey:@"E4QToqdgaxg9huTa"
                                        authType:SSDKAuthTypeBoth];
                     break;
                     
                 default:
                     break;
             }
         }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
