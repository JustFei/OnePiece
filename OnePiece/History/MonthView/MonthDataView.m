//
//  MonthDataView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MonthDataView.h"

@implementation MonthDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MonthDataView" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)setModel:(MonthHistoryModel *)model
{
    self.avMotionLabel.text = model.averageStep;
    self.avAggressivenessLabel.text = model.averageAggressiveness;
    self.avSleepLabel.text = model.averageSleep;
    self.winLabel.text = model.monthWin;
    self.drawLabel.text = model.monthDraw;
    self.failLabel.text = model.monthFail;
    self.PKCountLabel.text = model.monthPKCount;
}

@end
