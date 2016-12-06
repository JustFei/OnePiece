//
//  UserInfoModel.m
//  ManridyApp
//
//  Created by JustFei on 16/10/13.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (instancetype)userInfoModelWithAccount:(NSString *)account andUserName:(NSString *)userName andGender:(NSInteger)gender andBirthday:(NSString *)birthday andHeight:(NSInteger)height andWeight:(NSInteger)weight andStepLength:(NSInteger)stepLength andStepTarget:(NSInteger)stepTarget andSleepTarget:(NSInteger)sleepTarget andPeripheralName:(NSString *)peripheralName andbindPeripheralUUID:(NSString *)peripherlUUID andPeripheralMac:(NSString *)peripheralMac
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
    model.bindPeripheralUUID = peripherlUUID;
    model.peripheralMac = peripheralMac;
    
    return model;
}

-(void)signUpInBackgroundWithBlock:(BmobBooleanResultBlock)block
{
    
}

@end
