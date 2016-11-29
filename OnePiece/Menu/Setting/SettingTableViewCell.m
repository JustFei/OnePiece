//
//  SettingTableViewCell.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "BindPerViewController.h"

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
