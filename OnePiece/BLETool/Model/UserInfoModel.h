//
//  UserInfoModel.h
//  ManridyApp
//
//  Created by JustFei on 16/10/13.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UserInfoModifyTypeAccount = 0,
    UserInfoModifyTypeUserName,
    UserInfoModifyTypeGender,
    UserInfoModifyTypeBirthday,
    UserInfoModifyTypeHeight,
    UserInfoModifyTypeWeight,
    UserInfoModifyTypeStepLength,
    UserInfoModifyTypeStepTarget,
    UserInfoModifyTypeSleepTarget,
    UserInfoModifyTypePeripheralName,
    UserInfoModifyTypePeripheralUUID
} UserInfoModifyType;

@interface UserInfoModel : NSObject
@property (nonatomic ,copy) NSString *account;
@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,copy) NSString *gender;
@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,assign) NSInteger height;
@property (nonatomic ,assign) NSInteger weight;
@property (nonatomic ,assign) NSInteger stepLength;
@property (nonatomic ,assign) NSInteger stepTarget;
@property (nonatomic ,assign) NSInteger sleepTarget;
@property (nonatomic ,copy) NSString *peripheralName;
@property (nonatomic ,copy) NSString *peripheralUUID;

+ (instancetype)userInfoModelWithAccount:(NSString *)account andUserName:(NSString *)userName andGender:(NSString *)gender andBirthday:(NSString *)birthday andHeight:(NSInteger)height andWeight:(NSInteger)weight andStepLength:(NSInteger)stepLength andStepTarget:(NSInteger)stepTarget andSleepTarget:(NSInteger)sleepTarget andPeripheralName:(NSString *)peripheralName andPeripheralUUID:(NSString *)peripheralUUID;

@end
