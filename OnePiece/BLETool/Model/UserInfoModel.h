//
//  UserInfoModel.h
//  ManridyApp
//
//  Created by JustFei on 16/10/13.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

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
    UserInfoModifyTypePeripheralUUID,
    UserInfoModifyTypePeripheralMac,
    UserInfoModifyTypeMoney
} UserInfoModifyType;

@interface UserInfoModel : BmobObject
@property (nonatomic ,copy) NSString *account;
@property (nonatomic ,copy) NSString *pwd;
@property (nonatomic ,copy) NSString *userName;
@property (nonatomic ,assign) NSInteger gender;
@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,assign) NSInteger height;
@property (nonatomic ,assign) NSInteger weight;
@property (nonatomic ,assign) NSInteger stepLength;
@property (nonatomic ,assign) NSInteger stepTarget;
@property (nonatomic ,assign) NSInteger sleepTarget;
@property (nonatomic ,copy) NSString *peripheralName;
@property (nonatomic ,copy) NSString *bindPeripheralUUID;
@property (nonatomic ,copy) NSString *peripheralMac;
@property (nonatomic ,copy) NSString *registTime;
@property (nonatomic ,copy) NSString *money;

+ (instancetype)userInfoModelWithAccount:(NSString *)account andUserName:(NSString *)userName andGender:(NSInteger)gender andBirthday:(NSString *)birthday andHeight:(NSInteger)height andWeight:(NSInteger)weight andStepLength:(NSInteger)stepLength andStepTarget:(NSInteger)stepTarget andSleepTarget:(NSInteger)sleepTarget andPeripheralName:(NSString *)peripheralName andbindPeripheralUUID:(NSString *)peripherlUUID andPeripheralMac:(NSString *)peripheralMac andRegistTime:(NSString *)registTime;

/**
 *	后台注册,返回注册结果
 *
 *	@param	block	返回成功还是失败
 */
-(void)signUpInBackgroundWithBlock:(BmobBooleanResultBlock)block;

@end
