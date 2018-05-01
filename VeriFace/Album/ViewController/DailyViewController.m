//
//  DailyViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/23.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "DailyViewController.h"

@interface DailyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *health;         /**< 健康*/
@property (weak, nonatomic) IBOutlet UILabel *stain;          /**< 色斑*/
@property (weak, nonatomic) IBOutlet UILabel *acne;           /**< 青春痘*/
@property (weak, nonatomic) IBOutlet UILabel *darkCircle;     /**< 黑眼圈*/
@property (weak, nonatomic) IBOutlet UILabel *suggest;        /**< 建议*/
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Daily";
    
    _textView.editable = NO;
    _health.text = _model.health;
    _stain.text = _model.stain;
    _acne.text = _model.acne;
    _darkCircle.text = _model.dark_circle;
    _suggest.text = _model.suggest;
    _textView.text = _model.dailyText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
