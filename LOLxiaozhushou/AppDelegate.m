//
//  AppDelegate.m
//  LOLxiaozhushou
//
//  Created by 李国灏 on 15/12/7.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "AppDelegate.h"
#import "WMPageController.h"
#import "HerosViewController.h"
#import "VideoViewController.h"
#import "InfoViewController.h"
#import "StrategyViewController.h"
#import "EventViewController.h"
#import "noticeViewController.h"
#import "ViewController.h"
#import "SliderViewController.h"
#import "LeftViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k_screenWidth*375, 49)];
    
    v.backgroundColor = [UIColor blackColor];
    
    [tabBarController.tabBar insertSubview:v atIndex:0];
    
    tabBarController.tabBar.opaque = YES;
    
    tabBarController.tabBar.tintColor=[UIColor colorWithRed:230/255.0 green:140/255.0 blue:50/255.0 alpha:1];
    
    WMPageController *FPage = [self setFirst];
    HerosViewController *herosVC=[[HerosViewController alloc]init];
    VideoViewController *videoVC=[[VideoViewController alloc]init];
    ViewController *settingVC=[[ViewController alloc]init];
    UINavigationController *first=[[UINavigationController alloc]initWithRootViewController:FPage];
    first.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"资讯" image:[UIImage imageNamed:@"news.png"] tag:100];
    UINavigationController *heros=[[UINavigationController alloc]initWithRootViewController:herosVC];
    heros.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"英雄" image:[UIImage imageNamed:@"heros.png"] tag:200];
    
    UINavigationController *video=[[UINavigationController alloc]initWithRootViewController:videoVC];
    video.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"视频" image:[UIImage imageNamed:@"video.png"] tag:400];
    UINavigationController *setting=[[UINavigationController alloc]initWithRootViewController:settingVC];
    setting.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"壁纸" image:[UIImage imageNamed:@"pic.png"] tag:500];
    
    tabBarController.viewControllers=@[first,heros,video,setting];
    SliderViewController *sliderVC =[[SliderViewController alloc]initWithRootVC:tabBarController];
    sliderVC.LeftVC=[[LeftViewController alloc]init];
    self.window.rootViewController=sliderVC;
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, k_screenWidth*200, 44)];
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.textAlignment=NSTextAlignmentCenter;
    titleLable.text=@"最新资讯";
    titleLable.font=[UIFont systemFontOfSize:22];
    FPage.navigationItem.titleView=titleLable;
    
    //配置分享功能
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"cf4c3a63ce71"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4936aa3d9f219a81"
                                       appSecret:@"c21fa672282a792b84573c294a4f1093"];
                 break;
                 
             default:
                 break;
         }
     }];
    return YES;
}

-(WMPageController *)setFirst
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        Class vcClass;
        NSString *title;
        switch (i) {
            case 0:
                vcClass = [InfoViewController class];
                title = @"最新";
                break;
            case 1:
                vcClass = [StrategyViewController class];
                title = @"攻略";
                break;
            case 2:
                vcClass = [EventViewController class];
                title = @"赛事";
                break;
            default:
                vcClass = [noticeViewController class];
                title = @"公告";
                break;
        }
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc]initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.menuItemWidth=80;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleSizeSelected = 15;
    return  pageVC;
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
