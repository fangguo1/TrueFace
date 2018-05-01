//
//  ShowViewController.h
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributesModel.h"

@interface ShowViewController : UITableViewController

@property (nonatomic, strong) AttributesModel *attributesModel;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *photoDate;

@end
