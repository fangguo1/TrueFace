//
//  MessageViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "MessageViewController.h"
#import "WHC_ModelSqlite.h"
#import "MessageModel.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *monthly;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Personal Information";
    
    NSArray *array = [WHCSqlite query:[MessageModel class]];
    MessageModel *model = [array objectAtIndex:0];
    _nickName.text = model.nickname;
    _age.text = model.age;
    _gender.text = model.gender;
    _monthly.text = model.monthlyBudget;
    _time.text = model.preferedRemindingTime;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
