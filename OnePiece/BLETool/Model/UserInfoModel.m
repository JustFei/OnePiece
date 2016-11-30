//
//  UserInfoModel.m
//  ManridyApp
//
//  Created by JustFei on 16/10/13.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (instancetype)userInfoModelWithAccount:(NSString *)account andUserName:(NSString *)userName andGender:(NSString *)gender andBirthday:(NSString *)birthday andHeight:(NSInteger)height andWeight:(NSInteger)weight andStepLength:(NSInteger)stepLength andStepTarget:(NSInteger)stepTarget andSleepTarget:(NSInteger)sleepTarget andPeripheralName:(NSString *)peripheralName andPeripheralUUID:(NSString *)peripheralUUID
{
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model.account = account;
    model.userName = userName;
    model.gender = gender;
    model.birthday = birthday;
    model.height = height;
    model.weight = weight;
    model.stepLength = stepLength;
    model.stepTarget = stepTarget;
    model.sleepTarget = sleepTarget;
    model.peripheralName = peripheralName;
    model.peripheralUUID = peripheralUUID;
    
    return model;
}

@end
