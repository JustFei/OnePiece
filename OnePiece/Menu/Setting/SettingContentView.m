//
//  SettingContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "SettingContentView.h"
#import "SettingTableViewCell.h"

@interface SettingContentView () < UITableViewDelegate , UITableViewDataSource>

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) UIDatePicker *datePickerView;

@end

@implementation SettingContentView

- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 64, kViewWidth, kViewHeight - 64);
}

#pragma mark - Action
- (void)showInfoDateView:(UITapGestureRecognizer *)tap
{
    self.timeLabel = (UILabel *)tap.view;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取到该cell的label对象，修改text
        self.timeLabel.text = self.title;
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    self.datePickerView = [[UIDatePicker alloc] initWithFrame:XXF_CGRectMake(0, 0, alert.view.frame.size.width - 30, 216)];
    self.datePickerView.datePickerMode = UIDatePickerModeTime;
    [self.datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    // 设置时区
    [self.datePickerView setTimeZone:[NSTimeZone localTimeZone]];
    // 设置当前显示时间
    [self.datePickerView setDate:[NSDate date] animated:YES];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    [self.datePickerView setLocale:locale];
    // 当值发生改变的时候调用的方法
    [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [alert.view addSubview:self.datePickerView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    self.title = [formatter stringFromDate:[NSDate date]];
    
    [[self findViewController:self] presentViewController:alert animated:YES completion:nil];
}


- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSLog(@"%@",datePicker.date);
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
        case 3:
            return 1;
            break;
            
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
            cell.nameLabel.hidden = YES;
            [cell.disbindButton setTitle:@"绑定手环" forState:UIControlStateNormal];
            cell.disbindButton.hidden = NO;
        }
            break;
        case 1:
        {
            cell.nameLabel.text = @"来电提醒";
            cell.timeSwitch.hidden = NO;
            cell.nameLabel.hidden = NO;
        }
            break;
        case 2:
        {
            cell.nameLabel.hidden = NO;
            cell.timeSwitch.hidden = NO;
            cell.timeLabel.hidden = NO;
            cell.timeLabel.text = @"00:00";
            cell.timeLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showInfoDateView:)];
            [cell.timeLabel addGestureRecognizer:tap];
            cell.tag = 100 + indexPath.row;
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

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.tableFooterView = [[UIView alloc] init];
        view.backgroundColor = kClearColor;
        view.allowsSelection = NO;
        view.delegate = self;
        view.dataSource = self;
        
        [self addSubview:view];
        [view registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
        _tableView = view;
    }
    
    return _tableView;
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
