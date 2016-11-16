//
//  ChangeUserTableViewCell.h
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;
@property (weak, nonatomic) IBOutlet UILabel *countryNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImageView;

@end
