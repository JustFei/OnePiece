//
//  SettingTableViewCell.h
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *disbindButton;
@property (weak, nonatomic) IBOutlet UISwitch *timeSwitch;

@property (nonatomic ,strong) NSMutableArray *timeArr;

@end
