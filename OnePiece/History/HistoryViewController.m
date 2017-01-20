//
//  HistoryViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "HistoryViewController.h"
#import "DayContentView.h"
#import "MonthContentView.h"
#import "FMDBTool.h"
#import "DayHistoryModel.h"
#import "MonthHistoryModel.h"

@interface HistoryViewController ()

@property (nonatomic ,strong) UIButton *dayButton;
@property (nonatomic ,strong) UIButton *monthButton;
@property (nonatomic ,strong) UIImageView *backImageView;
@property (nonatomic ,weak) DayContentView *dayContentView;
@property (nonatomic ,weak) MonthContentView *monthContentView;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,copy) NSString *currentDateString;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
    self.navigationItem.title = @"历史";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.currentDateString = [formatter stringFromDate:[NSDate date]];
    [self getHistoryFromDataBase];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

#pragma mark - DataBase
- (void)getHistoryFromDataBase
{
    NSArray *userArr = [self.myFmdbTool queryAllUserInfo];
    [self getDateFromBeginWithUserArr:userArr];
    
    for (NSString *date in self.dayContentView.dateArr) {
        DayHistoryModel *dayModel = [[DayHistoryModel alloc] init];
        //目标
        dayModel.stepTarget = [NSString stringWithFormat:@"%ld",(long)((UserInfoModel *)userArr.firstObject).stepTarget];
        
        NSArray *stepArr = [self.myFmdbTool queryStepWithDate:date];
        NSArray *sleepArr = [self.myFmdbTool querySleepWithDate:date];
        NSArray *pkArr = [self.myFmdbTool queryPKDataWithData:date];
        float sumSum = 0;
        float sumDeep = 0;
        float sumLow = 0;
        
        if (stepArr.count != 0) {
            SportModel *stepModel = stepArr.firstObject;
            //步数
            dayModel.step = stepModel.stepNumber;
        }else {
            dayModel.step = @"0";
        }
        
        if (sleepArr.count != 0) {
            for (SleepModel *sleepModel in sleepArr) {
                sumSum += sleepModel.sumSleep.floatValue;
                sumDeep += sleepModel.deepSleep.floatValue;
                sumLow += sleepModel.lowSleep.floatValue;
            }
            //总睡眠，深睡眠，浅睡眠
            dayModel.sumSleep = [NSString stringWithFormat:@"%.1f",sumSum / 60];
            dayModel.deepSleep = [NSString stringWithFormat:@"%.1f",sumDeep / 60];
            dayModel.lowSleep = [NSString stringWithFormat:@"%.1f",sumLow / 60];
        }else {
            dayModel.sumSleep = @"0";
            dayModel.deepSleep = @"0";
            dayModel.lowSleep = @"0";
        }
        
        //霸气值
        float stepAngry = dayModel.step.floatValue / 10 * 0.5;
        float sleepAngry = (dayModel.sumSleep.floatValue / 8.f) * stepAngry * 0.5;
        dayModel.aggressiveness = [NSString stringWithFormat:@"%d",(int)(stepAngry + sleepAngry)];
        
        //胜利，平局，失败，总比拼次数
        if (pkArr.count != 0) {
            
            PKModel *pkModel = pkArr.firstObject;
            dayModel.win = pkModel.win;
            dayModel.draw = pkModel.draw;
            dayModel.fail = pkModel.fail;
            dayModel.PKCount = pkModel.PKCount;
            
        }else {
            dayModel.win = @"0";
            dayModel.draw = @"0";
            dayModel.fail = @"0";
            dayModel.PKCount = @"0";
        }
        //通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.dayContentView.dataArr addObject:dayModel];
//        });
        
    }
    
    //遍历迄今为止所有的月份
    for (NSString *month in self.monthContentView.monthArr) {
        
        float monthSumStep = 0;
        float monthSumSleep = 0;
        float monthSumAggressiveness = 0;
        float monthSumWin = 0;
        float monthSumDraw = 0;
        float monthSumFail = 0;
        float monthSumPKCount = 0;
        int days = 0;
        
        for (int i = 0; i < self.dayContentView.dateArr.count; i ++) {
            NSString *date = [self.dayContentView.dateArr[i] substringToIndex:7];
            if ([date isEqualToString:month]) {
                DayHistoryModel *dayModel = self.dayContentView.dataArr[i];
                days ++;
                monthSumStep += dayModel.step.floatValue;
                monthSumSleep += dayModel.sumSleep.floatValue;
                monthSumAggressiveness += dayModel.aggressiveness.floatValue;
                monthSumWin += dayModel.win.floatValue;
                monthSumDraw += dayModel.draw.floatValue;
                monthSumFail += dayModel.fail.floatValue;
                monthSumPKCount += dayModel.PKCount.floatValue;
            }
        }
        //求出平均值
        MonthHistoryModel *monthModel = [[MonthHistoryModel alloc] init];
        monthModel.averageStep = [NSString stringWithFormat:@"%.0f",monthSumStep / days];
        monthModel.averageSleep = [NSString stringWithFormat:@"%.0f",monthSumSleep / days];
        monthModel.averageAggressiveness = [NSString stringWithFormat:@"%.0f",monthSumAggressiveness / days];
        monthModel.monthWin = [NSString stringWithFormat:@"%.0f",monthSumWin / days];
        monthModel.monthDraw = [NSString stringWithFormat:@"%.0f",monthSumDraw / days];
        monthModel.monthFail = [NSString stringWithFormat:@"%.0f",monthSumFail / days];
        monthModel.monthPKCount = [NSString stringWithFormat:@"%.0f",monthSumPKCount / days];
        
        //通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.monthContentView.dataArr addObject:monthModel];
//        });
        
    }
}

- (NSMutableArray *)getDateFromBeginWithUserArr:(NSArray *)userArr
{
    self.dayContentView.dateArr = [NSMutableArray array];
    UserInfoModel *userModel = userArr.firstObject;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:userModel.registTime];
    long long nowTime = [inputDate timeIntervalSince1970];
    long long endTime = [[NSDate date] timeIntervalSince1970];
    
    long long dayTime = 24*60*60,
    time = nowTime - nowTime%dayTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    while (time <= endTime) {
        NSString *dayStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        NSString *monthStr = [dayStr substringToIndex:7];
        [self.dayContentView.dateArr addObject:dayStr];
        if (![self.monthContentView.monthArr containsObject:monthStr]) {
            [self.monthContentView.monthArr addObject:monthStr];
        }
        time += dayTime;
    }
    
    return self.dayContentView.dateArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI
{
    self.view.backgroundColor = kBackGroundColor;
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"History_background"]];
    [self.backImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.backImageView];
    self.backImageView.frame = self.view.frame;
    DLog(@"view.frame = %@, backimageView.frame = %@",NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.backImageView.frame));
    
    self.dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dayButton setImage:[UIImage imageNamed:@"DayButton"] forState:UIControlStateNormal];
    [self.dayButton setImage:[UIImage imageNamed:@"DaySelectButton"] forState:UIControlStateSelected];
    self.dayButton.frame = XXF_CGRectMake(0, 74, 110, 40);
    [self.dayButton addTarget:self action:@selector(dayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dayButton];
    self.dayButton.selected = YES;
    
    self.monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.monthButton setImage:[UIImage imageNamed:@"MonthButton"] forState:UIControlStateNormal];
    [self.monthButton setImage:[UIImage imageNamed:@"MonthSelectButton"] forState:UIControlStateSelected];
    self.monthButton.frame = XXF_CGRectMake(kControllerWidth - 110, 74, 110, 40);
    [self.monthButton addTarget:self action:@selector(monthAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.monthButton];
    
    self.dayContentView.backgroundColor = kClearColor;
    self.monthContentView.backgroundColor = kClearColor;
}

#pragma mark - Action
- (void)dayAction:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = !sender.selected;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.dayContentView.hidden = NO;
            self.dayContentView.frame = XXF_CGRectMake(0, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height);
            self.monthContentView.frame = XXF_CGRectMake(kControllerWidth, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height);
            
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.monthContentView.hidden = YES;
            self.monthButton.selected = NO;
        });
    }
}

- (void)monthAction:(UIButton *)sender
{
    if (!sender.selected) {
        sender.selected = !sender.selected;
        [UIView animateWithDuration:0.2 animations:^{
            self.monthContentView.hidden = NO;
            self.dayContentView.frame = CGRectMake(- kControllerWidth, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height);
            self.monthContentView.frame = CGRectMake(0, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height);
            
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.dayContentView.hidden = YES;
            self.dayButton.selected = NO;
        });
    }
}

#pragma mark - 懒加载
- (DayContentView *)dayContentView
{
    if (!_dayContentView) {
        DayContentView *view = [[DayContentView alloc] initWithFrame:XXF_CGRectMake(0, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth,  kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height)];
        
        [self.view addSubview:view];
        _dayContentView = view;
    }
    
    return _dayContentView;
}

- (MonthContentView *)monthContentView
{
    if (!_monthContentView) {
        MonthContentView *view = [[MonthContentView alloc] initWithFrame:XXF_CGRectMake(kControllerWidth, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height)];
        view.hidden = YES;
        
        [self.view addSubview:view];
        _monthContentView = view;
    }
    
    return _monthContentView;
}

- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    
    return _myFmdbTool;
}


@end
