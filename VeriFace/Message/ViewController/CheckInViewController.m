//
//  CheckInViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/23.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "CheckInViewController.h"
#import "ValuePickerView.h"
#import "SVProgressHUD+showTime.h"
#import "WHC_ModelSqlite.h"
#import "MessageModel.h"
#import "AppDelegate.h"
#import "TabBarController.h"
#import "PGDatePickManager.h"

#define D_ISHight(K) [[UIDevice currentDevice].systemVersion floatValue]>=K

@interface CheckInViewController () <UITextFieldDelegate, PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *MonthlyBudget;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *gender;

@end

@implementation CheckInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Personal Information";
    _MonthlyBudget.delegate = self;
    _time.delegate = self;
    _time.text = @"08:00";
    
    _nickName.delegate = self;
    _age.delegate = self;
    
}
- (IBAction)showMonthlyBudget:(id)sender
{
    [self selectTextField:_MonthlyBudget array:@[@"Under 50USD", @"50USD-100USD", @"100USD-300USD", @"300USD-1000USD", @"Above 1000USD"] titleText:@"Monthly Budget"];
}

- (IBAction)genderAction:(id)sender
{
    [self selectTextField:_gender array:@[@"male",@"female"] titleText:@"Gender"];
}

- (IBAction)remindTime:(id)sender
{    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerMode = PGDatePickerModeTime;
    [self presentViewController:datePickManager animated:YES completion:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    
    _time.text = [NSString stringWithFormat:@"%02ld:%02ld", dateComponents.hour, dateComponents.minute];
    
}

- (IBAction)submit:(id)sender
{
    if (_MonthlyBudget.text.length == 0 ||
        _time.text.length == 0 ||
        _nickName.text.length == 0 ||
        _age.text.length == 0 ||
        _gender.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"Can not empty."];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"saveMessage" forKey:@"store.daily.message"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MessageModel *messageModel = [[MessageModel alloc] init];
    messageModel.nickname = _nickName.text;
    messageModel.age = _age.text;
    messageModel.gender = _gender.text;
    messageModel.monthlyBudget = _MonthlyBudget.text;
    messageModel.preferedRemindingTime = _time.text;
    
    [WHC_ModelSqlite insert:messageModel];
    [SVProgressHUD showSuccessWithStatus:@"Success"];
    
    [self addLocalNotification];
    
    AppDelegate *app = [AppDelegate sharedAppDelegate];
    
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarController *viewController = (TabBarController *)[stroyBoard instantiateViewControllerWithIdentifier:@"TabBarController"];
    app.window.rootViewController = viewController;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)selectTextField:(UITextField *)textField array:(NSArray *)array titleText:(NSString *)titleText {
    
    ValuePickerView *pickerView = [[ValuePickerView alloc] init];
    pickerView.dataSource = array;
    pickerView.pickerTitle = titleText;
    pickerView.valueDidSelect = ^(NSString *value) {
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        textField.text = stateArr[0];
    };
    [pickerView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 添加本地通知

- (void)addLocalNotification
{
    if (D_ISHight(8.0)) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];  //注册通知
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDateFormatter * forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"HH:mm:ss"];
    localNotification.fireDate = [forma dateFromString:_time.text];   //12点提醒
    [localNotification setRepeatInterval:NSCalendarUnitDay];
    
    if (D_ISHight(8.2)) {
        [localNotification setAlertTitle:@"Reminder"];
    }
    [localNotification setAlertBody:@"Please Don't forget to record your face condition today and keep embracing change."];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];    //调用通知
    
}

@end
