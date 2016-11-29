//
//  SettingTableViewCell.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "BindPerViewController.h"
#import "BLETool.h"
#import "ClockModel.h"
#import "FMDBTool.h"

@interface SettingTableViewCell ()

@property (nonatomic ,strong) BLETool *myBleTool;
@property (nonatomic ,strong) UIAlertController *alertController;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;

@end

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)bindPeripheralAction:(UIButton *)sender
{
    BindPerViewController *vc = [[BindPerViewController alloc] init];
    if ([sender.titleLabel.text isEqualToString:@"绑定手环"]) {
        [[self findViewController:self].navigationController pushViewController:vc animated:YES];
    }else {
        [vc disBindPeripheral];
        self.nameLabel.hidden = YES;
        [sender setTitle:@"绑定手环" forState:UIControlStateNormal];
    }
}
- (IBAction)changeTimeSwitch:(UISwitch *)sender
{
    if (self.myBleTool.connectState == kBLEstateDidConnected) {
        if (sender.isOn) {
            self.timeButton.enabled = sender.isOn;
        }else {
            self.timeButton.enabled = sender.isOn;
        }
        
        //替换掉原来数组中的闹钟数据
        ClockModel *model = self.timeArr[self.tag - 10];
        model.isOpen = sender.on;
        [self.timeArr replaceObjectAtIndex:self.tag - 10 withObject:model];
        
        //将闹钟数据写入设备和数据库
        [self.myBleTool writeClockToPeripheral:ClockDataSetClock withClockArr:self.timeArr];
        [self.myFmdbTool deleteClockData:4];        //因为是三条数据整体写入，所以写入前需要删除之前数据库里面的数据
        for (ClockModel *model in self.timeArr) {
            [self.myFmdbTool insertClockModel:model];
        }
    }else {
        sender.on = !sender.on;
        [[self findViewController:self] presentViewController:self.alertController animated:YES completion:nil];
    }
    
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

#pragma mark - 懒加载
- (BLETool *)myBleTool
{
    if (!_myBleTool) {
        _myBleTool = [BLETool shareInstance];
    }
    
    return _myBleTool;
}

- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        _myFmdbTool = [[FMDBTool alloc] initWithPath:@"UserList"];
    }
    return _myFmdbTool;
}

- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请连接上设备后再操作" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:ac];
    }
    
    return _alertController;
}

@end
