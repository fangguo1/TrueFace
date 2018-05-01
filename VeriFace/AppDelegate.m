//
//  AppDelegate.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD+showTime.h"
#import "CheckInViewController.h"
#import "TabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *numString = [[NSUserDefaults standardUserDefaults] objectForKey:@"store.daily.message"];
    if (numString.length == 0) {
    
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        CheckInViewController *viewController = (CheckInViewController *)[stroyBoard instantiateViewControllerWithIdentifier:@"CheckInViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        self.window.rootViewController = nav;
    } else {
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarController *viewController = (TabBarController *)[stroyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = viewController;
    }
    [self initSVProgressHUD];
    
    return YES;
}

#pragma mark 初始化 SVProgressHUD 的配置

-(void)initSVProgressHUD {
    [SVProgressHUD setMinShowTime:1.50f];
    [SVProgressHUD setSuccessTime:1.50f];
    [SVProgressHUD setErrorTime:1.50f];
    [SVProgressHUD setInfoTime:1.50f];
    [SVProgressHUD isUseDefaultSetting:NO];
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
