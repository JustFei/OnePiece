//
//  FMDBTool.m
//  ManridyApp
//
//  Created by JustFei on 16/10/9.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import "FMDBTool.h"
//#import "ClockModel.h"
//#import "SportModel.h"
//#import "HeartRateModel.h"
//#import "SleepModel.h"
//#import "BloodModel.h"
//#import "BloodO2Model.h"
//#import "PKModel.h"

@interface FMDBTool ()

@property (nonatomic ,strong) NSArray *userInfoTypeArr;

@end

@implementation FMDBTool

static FMDatabase *_fmdb;

#pragma mark - init
/**
 *  创建数据库文件
 *
 *  @param path 数据库名字，以用户名+MotionData命名
 *
 */
- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.sqlite",path]];
        _fmdb = [FMDatabase databaseWithPath:filepath];
        
        DLog(@"数据库路径 == %@", filepath);
        
        if ([_fmdb open]) {
            DLog(@"数据库打开成功");
        }
        
        //UserInfoData
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists UserInfoData(id integer primary key, account text, username text, gender integer, birthday text, height integer, weight integer, steplength integer, steptarget integer, sleeptarget integer, peripheralName text, bindPeripheralUUID text, peripheralMac text, registTime text, money text);"]];
        
        //ClockData
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists ClockData(id integer primary key, time text, isopen bool);"]];

        //MotionData
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists MotionData(id integer primary key, date text, step text, kCal text, mileage text, currentDataCount integer, sumDataCount integer);"]];
        
        //HeartRateData
//        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists HeartRateData(id integer primary key,date text, time text, heartRate text);"]];
        
        //BloodData
//        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists BloodData(id integer primary key, day text, time text, highBlood text, lowBlood text, currentCount text, sumCount text, bpm text);"]];
        
        //BloodO2Data
//        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists BloodO2Data(id integer primary key, day text, time text, bloodO2integer text, bloodO2float text, currentCount text, sumCount text);"]];
        
        //SleepData
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists SleepData(id integer primary key,date text, startTime text, endTime text, deepSleep text, lowSleep text, sumSleep text, currentDataCount integer, sumDataCount integer);"]];
        
        [_fmdb executeUpdate:[NSString stringWithFormat:@"create table if not exists PKData(id integer primary key, date text, win text, draw text, fail text, PKCount text);"]];
    }
    
    return self;
}

#pragma mark - PKData
- (BOOL)insertPKData:(PKModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO PKData(date, win, draw, fail, PKCount) VALUES ('%@', '%@', '%@', '%@', '%@');",model.date ,model.win ,model.draw ,model.fail ,model.PKCount];
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入PKData成功");
    }else {
        DLog(@"插入PKData失败");
    }
    return result;
}

- (NSMutableArray *)queryPKDataWithData:(NSString *)date
{
    NSString *queryString;
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM PKData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        queryString = [NSString stringWithFormat:@"SELECT * FROM PKData where date = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *date = [set stringForColumn:@"date"];
        NSString *win = [set stringForColumn:@"win"];
        NSString *draw = [set stringForColumn:@"draw"];
        NSString *fail = [set stringForColumn:@"fail"];
        NSString *PKCount = [set stringForColumn:@"PKCount"];
        
        PKModel *model = [[PKModel alloc] init];
        
        model.date = date;
        model.win = win;
        model.draw = draw;
        model.fail = fail;
        model.PKCount = PKCount;
        
        [arrM addObject:model];
    }
    DLog(@"PK查询成功");
    return arrM;
}

- (BOOL)modifyPKDataWithDate:(NSString *)date model:(PKModel *)model
{
    if (date == nil) {
        DLog(@"传入的日期为空，不能修改");
        
        return NO;
    }
    NSString *modifySql = [NSString stringWithFormat:@"update PKData set win = ?, draw = ?, fail = ?, PKCount = ? where date = ?" ];
    BOOL modifyResult = [_fmdb executeUpdate:modifySql, model.win, model.draw, model.fail, model.PKCount, date];
    
    if (modifyResult) {
        DLog(@"PK数据修改成功");
    }else {
        DLog(@"PK数据修改失败");
    }
    
    return modifyResult;
}

- (BOOL)deletePkData:(NSInteger)deleteSql
{
    BOOL result;
    
    if (deleteSql == 4) {
        result =  [_fmdb executeUpdate:@"DELETE FROM PkData"];
    }else {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"DELETE FROM PkData WHERE id = ?"];
        
        result = [_fmdb executeUpdate:deleteSqlStr,[NSNumber numberWithInteger:deleteSql]];
    }
    if (result) {
        DLog(@"删除pkData成功");
    }else {
        DLog(@"删除pkData失败");
    }
    
    return result;
}

#pragma mark - ClockData
- (BOOL)insertClockModel:(ClockModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO ClockData(time, isopen) VALUES ('%@', '%d');", model.time, model.isOpen];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入clockData成功");
    }else {
        DLog(@"插入clockData失败");
    }
    return result;
}

- (NSMutableArray *)queryClockData
{
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM ClockData;"];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:queryString];
    
    while ([set next]) {
        
        ClockModel *model = [[ClockModel alloc] init];
        
        model.time = [set stringForColumn:@"time"];
        model.isOpen = [set boolForColumn:@"isopen"];
        model.ID = [set intForColumn:@"id"];
        
        //DLog(@"闹钟时间 == %@，是否打开 == %d, id == %ld",model.time , model.isOpen , (long)model.ID);
        
        [arrM addObject:model];
    }
    
    DLog(@"查询成功");
    return arrM;
}

- (BOOL)deleteClockData:(NSInteger)deleteSql
{
    BOOL result;
    
    if (deleteSql == 4) {
        result =  [_fmdb executeUpdate:@"DELETE FROM ClockData"];
    }else {
        NSString *deleteSqlStr = [NSString stringWithFormat:@"DELETE FROM ClockData WHERE id = ?"];
        
        result = [_fmdb executeUpdate:deleteSqlStr,[NSNumber numberWithInteger:deleteSql]];
    }
    if (result) {
        DLog(@"删除clockData成功");
    }else {
        DLog(@"删除clockData失败");
    }
    
    return result;
}

- (BOOL)modifyClockModel:(ClockModel *)model withModifyID:(NSInteger)ID
{
    NSString *modifySqlTime = [NSString stringWithFormat:@"update ClockData set time = ? , isopen = ? where id = ?" ];
    BOOL result = result = [_fmdb executeUpdate:modifySqlTime, model.time, [NSNumber numberWithBool:model.isOpen], [NSNumber numberWithInteger:ID]];
    
    if (result) {
        DLog(@"修改clockData成功");
    }else {
        DLog(@"修改clockData失败");
    }
    
    return result;
}

#pragma mark - StepData
/**
 *  插入数据模型
 *
 *  @param model 运动数据模型
 *
 *  @return 是否成功
 */
- (BOOL)insertStepModel:(SportModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO MotionData(date, step, kCal, mileage, currentDataCount, sumDataCount) VALUES ('%@', '%@', '%@', '%@', '%@', '%@');", model.date, model.stepNumber, model.kCalNumber, model.mileageNumber, [NSNumber numberWithInteger: model.currentDataCount],[NSNumber numberWithInteger:model.sumDataCount]];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入Motion数据成功");
    }else {
        DLog(@"插入Motion数据失败");
    }
    return result;
}

/**
 *  查找数据
 *
 *  @param date 查找的关键字
 *
 *  @return 返回所有查找的结果
 */
- (NSArray *)queryStepWithDate:(NSString *)date {
    
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM MotionData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        //这里一定不能将？用需要查询的日期代替掉
        queryString = [NSString stringWithFormat:@"SELECT * FROM MotionData where date = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    
    while ([set next]) {
        
        NSString *step = [set stringForColumn:@"step"];
        NSString *kCal = [set stringForColumn:@"kCal"];
        NSString *mileage = [set stringForColumn:@"mileage"];
        NSInteger currentDataCount = [set stringForColumn:@"currentDataCount"].integerValue;
        NSInteger sumDataCount = [set stringForColumn:@"sumDataCount"].integerValue;
        
        SportModel *model = [[SportModel alloc] init];
        
        model.date = date;
        model.stepNumber = step;
        model.kCalNumber = kCal;
        model.mileageNumber = mileage;
        model.currentDataCount = currentDataCount;
        model.sumDataCount = sumDataCount;
        
//        DLog(@"%@的数据：步数=%@，卡路里=%@，里程=%@",date ,step ,kCal ,mileage);
        
        [arrM addObject:model];
    }
    
    DLog(@"Motion查询成功");
    return arrM;
}

/**
 *  修改数据内容
 *
 *  @param date  需要修改的日期
 *  @param model 需要修改的模型内容
 *
 *  @return 是否修改成功
 */
- (BOOL)modifyStepWithDate:(NSString *)date model:(SportModel *)model
{
    if (date == nil) {
        DLog(@"传入的日期为空，不能修改");
        
        return NO;
    }
    
    NSString *modifySql = [NSString stringWithFormat:@"update MotionData set step = ?, kCal = ?, mileage = ? where date = ?" ];
    
    BOOL modifyResult = [_fmdb executeUpdate:modifySql, model.stepNumber, model.kCalNumber, model.mileageNumber, date];
    
    if (modifyResult) {
        DLog(@"Motion数据修改成功");
    }else {
        DLog(@"Motion数据修改失败");
    }
   
    return modifyResult;
}

#pragma mark - HeartRateData
- (BOOL)insertHeartRateModel:(HeartRateModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO HeartRateData(date, time, heartRate) VALUES ('%@', '%@', '%@');", model.date, model.time, model.heartRate];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入HeartRate数据成功");
    }else {
        DLog(@"插入HeartRate数据失败");
    }
    return result;
}

- (NSArray *)queryHeartRateWithDate:(NSString *)date
{
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM HeartRateData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        queryString = [NSString stringWithFormat:@"SELECT * FROM HeartRateData where date = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *time = [set stringForColumn:@"time"];
        NSString *heartRate = [set stringForColumn:@"heartRate"];
        NSString *date = [set stringForColumn:@"date"];
        
        HeartRateModel *model = [[HeartRateModel alloc] init];
        
        model.time = time;
        model.heartRate = heartRate;
        model.date = date;
        
        [arrM addObject:model];
    }
    DLog(@"heartRate查询成功");
    return arrM;
}

- (BOOL)deleteHeartRateData:(NSString *)deleteSql
{
    BOOL result = [_fmdb executeUpdate:@"delete from HeartRateData;"];
    
    if (result) {
        DLog(@"删除成功");
    }else {
        DLog(@"删除失败");
    }
    
    return result;
}

#pragma mark - TemperatureData

#pragma mark - SleepData
- (BOOL)insertSleepModel:(SleepModel *)model
{
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO SleepData(date, startTime, endTime, deepSleep, lowSleep, sumSleep, currentDataCount, sumDataCount) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.date, model.startTime, model.endTime, model.deepSleep, model.lowSleep, model.sumSleep, [NSNumber numberWithInteger:model.currentDataCount],[NSNumber numberWithInteger:model.sumDataCount]];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入SleepData数据成功");
    }else {
        DLog(@"插入SleepData数据失败");
    }
    return result;
}

- (NSArray *)querySleepWithDate:(NSString *)date
{
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM SleepData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        queryString = [NSString stringWithFormat:@"SELECT * FROM SleepData where date = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *startTime = [set stringForColumn:@"startTime"];
        NSString *endTime = [set stringForColumn:@"endTime"];
        NSString *deepSleep = [set stringForColumn:@"deepSleep"];
        NSString *lowSleep = [set stringForColumn:@"lowSleep"];
        NSString *sumSleep = [set stringForColumn:@"sumSleep"];
        NSInteger currentDataCount = [set intForColumn:@"currentDataCount"];
        NSInteger sumDataCount = [set intForColumn:@"sumDataCount"];
        
        SleepModel *model = [[SleepModel alloc] init];
        
        model.startTime = startTime;
        model.endTime = endTime;
        model.deepSleep = deepSleep;
        model.lowSleep = lowSleep;
        model.sumSleep = sumSleep;
        model.currentDataCount = currentDataCount;
        model.sumDataCount = sumDataCount;
        model.date = date;
        
//        DLog(@"currentDataCount == %ld, sumDataCount == %ld, lowSleep == %@, deepSleep == %@, sumSleep == %@",(long)currentDataCount ,(long)sumDataCount ,lowSleep , deepSleep ,sumSleep);
        
        [arrM addObject:model];
    }
    
    DLog(@"sleep查询成功");
    return arrM;
}

- (BOOL)modifySleepWithID:(NSInteger)ID model:(SleepModel *)model
{
    return YES;
}

- (BOOL)deleteSleepData:(NSString *)deleteSql
{
    BOOL result = [_fmdb executeUpdate:@"delete from SleepData"];
    
    if (result) {
        DLog(@"Sleep表删除成功");
    }else {
        DLog(@"Sleep表删除失败");
    }
    
    return result;
}

#pragma mark - BloodPressureData
- (BOOL)insertBloodModel:(BloodModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO BloodData(day, time, highBlood, lowBlood, currentCount, sumCount, bpm) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.dayString, model.timeString, model.highBloodString, model.lowBloodString, model.currentCount, model.sumCount, model.bpmString];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入BloodData数据成功");
    }else {
        DLog(@"插入BloodData数据失败");
    }
    return result;
}

- (NSArray *)queryBloodWithDate:(NSString *)date
{
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM BloodData;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        queryString = [NSString stringWithFormat:@"SELECT * FROM BloodData where day = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *day = [set stringForColumn:@"day"];
        NSString *time = [set stringForColumn:@"time"];
        NSString *highBlood = [set stringForColumn:@"highBlood"];
        NSString *lowBlood = [set stringForColumn:@"lowBlood"];
        NSString *currentCount = [set stringForColumn:@"currentCount"];
        NSString *sumCount = [set stringForColumn:@"sumCount"];
        NSString *bpmString = [set stringForColumn:@"bpm"];
        
        BloodModel *model = [[BloodModel alloc] init];
        
        model.dayString = day;
        model.timeString = time;
        model.highBloodString = highBlood;
        model.lowBloodString = lowBlood;
        model.currentCount = currentCount;
        model.sumCount = sumCount;
        model.bpmString = bpmString;
        
        [arrM addObject:model];
    }
    DLog(@"Blood查询成功");
    return arrM;
}

- (BOOL)deleteBloodData:(NSString *)deleteSql
{
    BOOL result = [_fmdb executeUpdate:@"drop table BloodData"];
    
    if (result) {
        DLog(@"Blood表删除成功");
    }else {
        DLog(@"Blood表删除失败");
    }
    
    return result;
}


#pragma mark - BloodO2Data
- (BOOL)insertBloodO2Model:(BloodO2Model *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO BloodO2Data(day, time, bloodO2integer, bloodO2float, currentCount, sumCount) VALUES ('%@', '%@', '%@', '%@', '%@', '%@');", model.dayString, model.timeString, model.integerString, model.floatString, model.currentCount, model.sumCount];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入BloodO2Data数据成功");
    }else {
        DLog(@"插入BloodO2Data数据失败");
    }
    return result;
}

- (NSArray *)queryBloodO2WithDate:(NSString *)date
{
    NSString *queryString;
    
    FMResultSet *set;
    
    if (date == nil) {
        queryString = [NSString stringWithFormat:@"SELECT * FROM BloodO2Data;"];
        
        set = [_fmdb executeQuery:queryString];
    }else {
        queryString = [NSString stringWithFormat:@"SELECT * FROM BloodO2Data where day = ?;"];
        
        set = [_fmdb executeQuery:queryString ,date];
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *day = [set stringForColumn:@"day"];
        NSString *time = [set stringForColumn:@"time"];
        NSString *bloodO2integer = [set stringForColumn:@"bloodO2integer"];
        NSString *bloodO2float = [set stringForColumn:@"bloodO2float"];
        NSString *currentCount = [set stringForColumn:@"currentCount"];
        NSString *sumCount = [set stringForColumn:@"sumCount"];
        
        BloodO2Model *model = [[BloodO2Model alloc] init];
        
        model.dayString = day;
        model.timeString = time;
        model.integerString = bloodO2integer;
        model.floatString = bloodO2float;
        model.currentCount = currentCount;
        model.sumCount = sumCount;
        
        [arrM addObject:model];
    }
    DLog(@"BloodO2查询成功");
    return arrM;
}

#pragma mark - UserInfoData
- (BOOL)insertUserInfoModel:(UserInfoModel *)model
{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO UserInfoData(account, username, gender, birthday, height, weight, steplength, steptarget, sleeptarget, peripheralName, bindPeripheralUUID, peripheralMac, registTime, money) VALUES ('%@', '%@', '%ld', '%@', '%ld', '%ld', '%ld', '%ld', '%ld', '%@', '%@', '%@', '%@', '%@');", model.account, model.userName, (long)model.gender, model.birthday, (long)model.height, (long)model.weight, (long)model.stepLength, (long)model.stepTarget, (long)model.sleepTarget, model.peripheralName, model.bindPeripheralUUID, model.peripheralMac, model.registTime, model.money];
    
    BOOL result = [_fmdb executeUpdate:insertSql];
    if (result) {
        DLog(@"插入UserInfoData数据成功");
    }else {
        DLog(@"插入UserInfoData数据失败");
    }
    return result;
}

- (NSArray *)queryAllUserInfo {
    
    NSString *queryString;
    
    queryString = [NSString stringWithFormat:@"SELECT * FROM UserInfoData;"];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:queryString];
    
    while ([set next]) {
        
        NSString *account = [set stringForColumn:@"account"];
        NSString *userName = [set stringForColumn:@"username"];
        NSInteger gender = [set intForColumn:@"gender"];
        NSString *birthday = [set stringForColumn:@"birthday"];
        NSInteger height = [set intForColumn:@"height"];
        NSInteger weight = [set intForColumn:@"weight"];
        NSInteger steplength = [set intForColumn:@"steplength"];
        NSInteger stepTarget = [set intForColumn:@"steptarget"];
        NSInteger sleepTarget = [set intForColumn:@"sleeptarget"];
        NSString *peripheralName = [set stringForColumn:@"peripheralName"];
        NSString *bindPeripheralUUID = [set stringForColumn:@"bindPeripheralUUID"];
        NSString *peripheralMac = [set stringForColumn:@"peripheralMac"];
        NSString *registTime = [set stringForColumn:@"registTime"];
        NSString *money = [set stringForColumn:@"money"];
        
        UserInfoModel *model = [UserInfoModel userInfoModelWithAccount:account andUserName:userName andGender:gender andBirthday:birthday andHeight:height andWeight:weight andStepLength:steplength andStepTarget:stepTarget andSleepTarget:sleepTarget andPeripheralName:peripheralName andbindPeripheralUUID:bindPeripheralUUID andPeripheralMac:peripheralMac andRegistTime:registTime];
        model.money = money;
        
//        DLog(@"%@,%@,%ld,%@,%ld,%ld,%ld,%ld,%ld,%@,%@,%@", model.account ,model.userName ,(long)model.gender ,model.birthday ,(long)model.height ,(long)model.weight ,(long)model.stepLength ,(long)model.stepTarget, (long)sleepTarget, model.peripheralName, model.bindPeripheralUUID,model.peripheralMac);
        
        [arrM addObject:model];
    }
    
    DLog(@"UserInfoData查询成功");
    return arrM;
}

- (BOOL)modifyUserInfoModel:(UserInfoModel *)model withModityType:(UserInfoModifyType)modifyType
{
    NSString *modifySql = [NSString stringWithFormat:@"update UserInfoData set %@ = ? where id = ?",self.userInfoTypeArr[modifyType]];
    BOOL modifyResult;
    
    switch (modifyType) {
        case UserInfoModifyTypeAccount:
            modifyResult = [_fmdb executeUpdate:modifySql, model.account, @(1)];
            break;
        case UserInfoModifyTypeUserName:
            modifyResult = [_fmdb executeUpdate:modifySql, model.userName, @(1)];
            break;
        case UserInfoModifyTypeGender:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.gender), @(1)];
            break;
        case UserInfoModifyTypeBirthday:
            modifyResult = [_fmdb executeUpdate:modifySql, model.birthday, @(1)];
            break;
        case UserInfoModifyTypeHeight:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.height), @(1)];
            break;
        case UserInfoModifyTypeWeight:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.weight), @(1)];
            break;
        case UserInfoModifyTypeStepLength:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.stepLength), @(1)];
            break;
        case UserInfoModifyTypeStepTarget:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.stepTarget), @(1)];
            break;
        case UserInfoModifyTypeSleepTarget:
            modifyResult = [_fmdb executeUpdate:modifySql, @(model.sleepTarget), @(1)];
            break;
        case UserInfoModifyTypePeripheralName:
            modifyResult = [_fmdb executeUpdate:modifySql, model.peripheralName, @(1)];
            break;
        case UserInfoModifyTypePeripheralUUID:
            modifyResult = [_fmdb executeUpdate:modifySql, model.bindPeripheralUUID, @(1)];
            break;
        case  UserInfoModifyTypePeripheralMac:
            modifyResult = [_fmdb executeUpdate:modifySql, model.peripheralMac, @(1)];
            break;
        case UserInfoModifyTypeMoney:
            modifyResult = [_fmdb executeUpdate:modifySql, model.money, @(1)];
            break;
            
        default:
            break;
    }
    
    if (modifyResult) {
        DLog(@"UserInfoData:%@ 数据修改成功",self.userInfoTypeArr[modifyType]);
    }else {
        DLog(@"UserInfoData:%@ 数据修改失败",self.userInfoTypeArr[modifyType]);
    }
    
    return modifyResult;
}

//- (BOOL)modifyStepTargetWithID:(NSInteger)ID model:(NSInteger)stepTarget
//{
//    NSString *modifySql = [NSString stringWithFormat:@"update UserInfoData set steptarget = ? where id = ?"];
//    
//    BOOL modifyResult = [_fmdb executeUpdate:modifySql, @(stepTarget), @(ID)];
//    
//    if (modifyResult) {
//        DLog(@"添加运动目标成功");
//    }else {
//        DLog(@"添加运动目标失败");
//    }
//    
//    return modifyResult;
//}
//
//- (BOOL)modifySleepTargetWithID:(NSInteger)ID model:(NSInteger)sleepTarget
//{
//    NSString *modifySql = [NSString stringWithFormat:@"update UserInfoData set sleeptarget = ? where id = ?"];
//    
//    BOOL modifyResult = [_fmdb executeUpdate:modifySql, @(sleepTarget), @(ID)];
//    
//    if (modifyResult) {
//        DLog(@"修改睡眠目标成功");
//    }else {
//        DLog(@"修改睡眠目标失败");
//    }
//    
//    return modifyResult;
//}

- (BOOL)deleteUserInfoData:(NSString *)deleteSql
{
    BOOL result = [_fmdb executeUpdate:@"drop table UserInfoData"];
    
    if (result) {
        DLog(@"UserInfo表删除成功");
    }else {
        DLog(@"UserInfo表删除失败");
    }
    
    return result;
}

#pragma mark - CloseData
- (void)CloseDataBase
{
    [_fmdb close];
}

#pragma mark - 懒加载
- (NSArray *)userInfoTypeArr
{
    if (!_userInfoTypeArr) {
        _userInfoTypeArr = @[@"account",@"username",@"gender",@"birthday",@"height",@"weight",@"steplength",@"steptarget",@"sleeptarget",@"peripheralName",@"bindPeripheralUUID",@"peripheralMac",@"money"];
    }
    
    return _userInfoTypeArr;
}


@end
