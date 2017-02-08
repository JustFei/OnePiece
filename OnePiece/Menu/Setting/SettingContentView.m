//
//  SettingContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "SettingContentView.h"
#import "SettingTableViewCell.h"
#import "BLETool.h"
#import "FMDBTool.h"

@interface SettingContentView () < UITableViewDelegate , UITableViewDataSource , BleReceiveDelegate >

@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) UIDatePicker *datePickerView;
@property (nonatomic ,strong) BLETool *myBleTool;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) NSMutableArray *timeArr;

@end

@implementation SettingContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeArr = [self.myFmdbTool queryClockData];
        if (self.timeArr.count == 0) {
            for (int i = 0; i < 3; i ++) {
                ClockModel *model = [[ClockModel alloc] init];
                model.time = @"08:00";
                model.isOpen = NO;
                [self.timeArr addObject:model];
            }
        }
//        if (self.myBleTool.connectState == kBLEstateDidConnected) {
//            [self.myBleTool writeClockToPeripheral:ClockDataGetClock withClockArr:nil];
//        }
    }
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 64, kViewWidth, kViewHeight - 64);
}

#pragma mark - Action
- (void)showInfoDateView:(UIButton *)sender
{
    self.title = sender.titleLabel.text;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //替换掉原来数组中的闹钟数据
    ClockModel *model = self.timeArr[sender.tag - 100];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取到该cell的label对象，修改text
        [sender setTitle:self.title forState:UIControlStateNormal];
        
        model.time = self.title;
        model.isOpen = sender.enabled;
        [self.timeArr replaceObjectAtIndex:sender.tag - 100 withObject:model];
        
        //将闹钟数据写入设备和数据库
        [self.myBleTool writeClockToPeripheral:ClockDataSetClock withClockArr:self.timeArr];
        [self.myFmdbTool deleteClockData:4];        //因为是三条数据整体写入，所以写入前需要删除之前数据库里面的数据
        for (ClockModel *model in self.timeArr) {
            [self.myFmdbTool insertClockModel:model];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:XXF_CGRectMake(0, 0, alert.view.frame.size.width - 30, 216)];
    self.datePickerView.datePickerMode = UIDatePickerModeTime;
    [self.datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    // 设置时区
    [self.datePickerView setTimeZone:[NSTimeZone localTimeZone]];
    // 设置当前显示时间为数据库中的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [self.datePickerView setDate:[formatter dateFromString:model.time]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [self.datePickerView setLocale:locale];
    // 当值发生改变的时候调用的方法
    [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [alert.view addSubview:self.datePickerView];
    
//    NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
//    [currentFormatter setDateFormat:@"hh:mm"];
//    self.title = [currentFormatter stringFromDate:[NSDate date]];
    
    [[self findViewController:self] presentViewController:alert animated:YES completion:nil];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    DLog(@"%@",datePicker.date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    self.title = [formatter stringFromDate:datePicker.date];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        //TODO:先关闭语言设置
        //case 3:
            //return 1;
            //break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    cell.backgroundColor = kWhiteColor;
    switch (indexPath.section) {
        case 0:
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"bindPeripheralName"]) {
                NSString *peripheralName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPeripheralName"];
                if (![peripheralName isEqualToString:@"0"]) {
                    cell.nameLabel.text = peripheralName;
                    cell.nameLabel.hidden = NO;
                    [cell.disbindButton setTitle:@"解除绑定" forState:UIControlStateNormal];
                    [cell.disbindButton setTitleColor:kRedColor forState:UIControlStateNormal];
                    cell.disbindButton.hidden = NO;
                }else {
                    cell.nameLabel.hidden = YES;
                    [cell.disbindButton setTitle:@"绑定手环" forState:UIControlStateNormal];
                    [cell.disbindButton setTitleColor:kBlueColor forState:UIControlStateNormal];
                    cell.disbindButton.hidden = NO;
                }
            }else {
                cell.nameLabel.hidden = YES;
                [cell.disbindButton setTitle:@"绑定手环" forState:UIControlStateNormal];
                cell.disbindButton.hidden = NO;
            }
        }
            break;
        case 1:
        {
            cell.nameLabel.text = @"来电提醒";
            cell.timeSwitch.hidden = NO;
            cell.nameLabel.hidden = NO;
            cell.timeSwitch.tag = 1001;
        }
            break;
        case 2:
        {
            cell.nameLabel.hidden = NO;
            cell.timeSwitch.hidden = NO;
            cell.timeButton.hidden = NO;
            
            ClockModel *model = self.timeArr[indexPath.row];
            [cell.timeButton setTitle:model.time forState:UIControlStateNormal];
            cell.timeButton.enabled = model.isOpen;
            [cell.timeSwitch setOn:model.isOpen];
            
            [cell.timeButton addTarget:self action:@selector(showInfoDateView:) forControlEvents:UIControlEventTouchUpInside];
            cell.timeArr = self.timeArr;
            
            cell.timeButton.tag = 100 + indexPath.row;
            cell.tag = 10 + indexPath.row;
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.nameLabel.text = @"闹钟1";
                }
                    break;
                case 1:
                {
                    cell.nameLabel.text = @"闹钟2";
                }
                    break;
                case 2:
                {
                    cell.nameLabel.text = @"闹钟3";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            cell.nameLabel.hidden = NO;
            cell.nameLabel.text = @"语言";
            cell.disbindButton.hidden = NO;
            [cell.disbindButton setTitle:@"默认" forState:UIControlStateNormal];
            cell.disbindButton.enabled = NO;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        SettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self showInfoDateView:cell.timeButton];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:XXF_CGRectMake(0, 0, kViewWidth, 20)];
    view.backgroundColor = kClearColor;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else {
        return 20 * kViewWidth / 375;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

//#pragma mark - BleReceiveDelegate
//- (void)receiveSetClockDataWithModel:(manridyModel *)manridyModel
//{
//    //暂时不用做什么操作
//}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.tableFooterView = [[UIView alloc] init];
        view.backgroundColor = kClearColor;
        view.allowsSelection = YES;
        view.delegate = self;
        view.dataSource = self;
        
        [self addSubview:view];
        [view registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
        _tableView = view;
    }
    
    return _tableView;
}

- (BLETool *)myBleTool
{
    if (!_myBleTool) {
        _myBleTool = [BLETool shareInstance];
//        _myBleTool.receiveDelegate = self;
        
    }
    return _myBleTool;
}

- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    
    return _myFmdbTool;
}

- (NSMutableArray *)timeArr
{
    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    
    return _timeArr;
}

#pragma mark - 获取当前View的控制器的方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


@end
