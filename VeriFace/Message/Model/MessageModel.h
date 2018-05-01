//
//  MessageModel.h
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/23.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *monthlyBudget;
@property (nonatomic, strong) NSString *preferedRemindingTime;
@property (nonatomic, strong) NSNumber *messageId;

@end
