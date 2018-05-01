//
//  DailyModel.h
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/23.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyModel : NSObject

@property (nonatomic, strong) NSString *acne;        /**< 青春痘*/
@property (nonatomic, strong) NSString *dark_circle; /**< 黑眼圈*/
@property (nonatomic, strong) NSString *health;      /**< 健康*/
@property (nonatomic, strong) NSString *stain;       /**< 色斑*/
@property (nonatomic, strong) NSString *suggest;
@property (nonatomic, strong) NSString *dailyText;
@property (nonatomic, strong) NSNumber *dailyId;
@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) NSString *date;

@end
