//
//  TabBarController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "TabBarController.h"
#import "AlbumViewController.h"
#import "MessageViewController.h"
#import "ScheduleViewController.h"

#define TABBARITEM @[@"Album",@"History",@"Personal Information"]

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.navigationController.navigationBarHidden = YES;
    AlbumViewController *albumView = [self viewController:[AlbumViewController class] stroyboardName:@"Album" stroyboardIdentifier:@"AlbumViewController" normalImage:@"itemCreditCardNo" selectImage:@"itemCreditCard" tag:0];
    
    ScheduleViewController *scheduleView = [self viewController:[ScheduleViewController class] stroyboardName:@"Schedule" stroyboardIdentifier:@"ScheduleViewController" normalImage:@"itemLoanNo" selectImage:@"itemLoan" tag:1];
    
    MessageViewController *messageView = [self viewController:[MessageViewController class] stroyboardName:@"Message" stroyboardIdentifier:@"MessageViewController" normalImage:@"itemMine" selectImage:@"itemMineNo" tag:2];
    
    self.viewControllers = @[albumView, scheduleView, messageView];
    self.selectedIndex = 0;
    self.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.title = viewController.tabBarItem.title;
}

#pragma mark Views
- (id)viewController:(id)ViewController stroyboardName:(NSString *)stroyboardName stroyboardIdentifier:(NSString *)stroyboardIdentifier normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage tag:(NSInteger)tag {
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:stroyboardName bundle:nil];
    UIViewController *viewController = (UIViewController *)[stroyBoard instantiateViewControllerWithIdentifier:stroyboardIdentifier];
    viewController.tabBarItem = [self tabBarTitle:TABBARITEM[tag] normalImage:normalImage selectImage:selectImage tag:tag];
    UINavigationController *navView = [[UINavigationController alloc] initWithRootViewController:viewController];
    navView.interactivePopGestureRecognizer.enabled = YES;
    navView.navigationController.navigationBarHidden = NO;
    return navView;
}

- (UITabBarItem *)tabBarTitle:(NSString *)title normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage tag:(NSInteger)tag {
    UIImage *image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *tabSelectImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageWithCGImage:[image CGImage] scale:(image.scale * 1.4) orientation:image.imageOrientation] selectedImage:[UIImage imageWithCGImage:[tabSelectImage CGImage] scale:(tabSelectImage.scale * 1.4) orientation:tabSelectImage.imageOrientation] ];
    
    self.tabBarController.tabBar.tintColor = [UIColor redColor];
    item.tag = tag;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
