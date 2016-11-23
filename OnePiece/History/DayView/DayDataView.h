//
//  DayDataView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayDataView : UIView

@property (weak, nonatomic) IBOutlet UILabel *motionLabel;

@property (nonatomic ,weak) IBOutlet UILabel *aggressivenessLabel;
@property (nonatomic ,weak) IBOutlet UILabel *motionTargetLabel;
@property (nonatomic ,weak) IBOutlet UILabel *sumSleepLabel;
@property (nonatomic ,weak) IBOutlet UILabel *deepSleepLabel;
@property (nonatomic ,weak) IBOutlet UILabel *lowSleepLabel;
@property (nonatomic ,weak) IBOutlet UILabel *winLabel;
@property (nonatomic ,weak) IBOutlet UILabel *drawLabel;
@property (nonatomic ,weak) IBOutlet UILabel *failLabel;
@property (nonatomic ,weak) IBOutlet UILabel *PKCountLabel;

@end
