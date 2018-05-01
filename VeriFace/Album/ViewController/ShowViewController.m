//
//  ShowViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "ShowViewController.h"
#import "DailyModel.h"
#import "WHC_ModelSqlite.h"
#import "SVProgressHUD+showTime.h"

@interface ShowViewController ()

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@property (weak, nonatomic) IBOutlet UILabel *health;         /**< 健康*/
@property (weak, nonatomic) IBOutlet UILabel *stain;          /**< 色斑*/
@property (weak, nonatomic) IBOutlet UILabel *acne;           /**< 青春痘*/
@property (weak, nonatomic) IBOutlet UILabel *darkCircle;     /**< 黑眼圈*/
@property (weak, nonatomic) IBOutlet UILabel *suggest;        /**< 建议*/
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *aArray = @[@"Hydration mask", @"Exfoliation", @"Anti-oxidant", @"Whitening mask", @"Soothing Mask"];
    NSArray *bArray = @[@"Drink plenty of water", @"Sun protection", @"Eat more vegetabe"];
    
    NSMutableArray *mAArray = [[NSMutableArray alloc] initWithArray:aArray];
    NSMutableArray *mBArray = [[NSMutableArray alloc] initWithArray:bArray];
    
    _health.text = [NSString stringWithFormat:@"%.2lf%@",[_attributesModel.health doubleValue] * 100, @"%"] ;
    _stain.text =  [_attributesModel.stain stringByAppendingString:@"%"];
    _acne.text = [_attributesModel.acne stringByAppendingString:@"%"];
    _darkCircle.text = [_attributesModel.dark_circle stringByAppendingString:@"%"];
    
    int count = arc4random() % [mAArray count];
    NSString *oneSuggest = [mAArray objectAtIndex:count];
    [mAArray removeObject:oneSuggest];
    
    count = arc4random() % [mAArray count];
    NSString *twoSuggest = [mAArray objectAtIndex:count];
    
    count = arc4random() % [mBArray count];
    NSString *threeSuggest = [mBArray objectAtIndex:count];
    
    _suggest.text = [NSString stringWithFormat:@"%@ , %@,\n %@", oneSuggest, twoSuggest, threeSuggest];
    _suggest.numberOfLines = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 添加按钮
    self.navigationItem.rightBarButtonItem = self.rightBarButton;

}

- (UIBarButtonItem *)rightBarButton {
    if (!_rightBarButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 50, 20);
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton addTarget:self
                        action:@selector(finishAction)
              forControlEvents:UIControlEventTouchUpInside];
        _rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    
    [(UIButton *)_rightBarButton.customView setTitle:@"Finish"
                                            forState:UIControlStateNormal];
    return _rightBarButton;
}

- (void)finishAction
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"store.daily.id"];
    int integerInt = 0;
    if ([num isEqualToNumber:@(0)]) {
        num = @1;
    }
    
    integerInt = [num intValue];
    integerInt++;
    
    DailyModel *dailyModel = [[DailyModel alloc] init];
    dailyModel.acne = _acne.text;
    dailyModel.dark_circle = _darkCircle.text;
    dailyModel.health = _health.text;
    dailyModel.stain = _stain.text;
    dailyModel.suggest = _suggest.text;
    dailyModel.dailyText = _textView.text;
    dailyModel.dailyId = @(integerInt);
    dailyModel.date = _photoDate;
    dailyModel.imageData = _imageData;
    BOOL success = [WHCSqlite insert:dailyModel];
    if (success) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@(integerInt) forKey:@"store.daily.id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"Failure, Please try again."];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    NSString *title = nil;
    if (section == 0) {
        title = @"Here are your results (scores are out of 100)";
    } else {
        title = @"product recommendation";
    }
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-30, 20)];
    headLabel.font = [UIFont systemFontOfSize:12.0f];
    headLabel.textColor = [UIColor grayColor];
    headLabel.text = title;
    [headLabel sizeToFit];
    [headView addSubview:headLabel];
    return headView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
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
