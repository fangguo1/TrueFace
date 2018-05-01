//
//  AppDelegate.h
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;

@end

