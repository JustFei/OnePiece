//
//  DayDataView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "DayDataView.h"

@implementation DayDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"DayDataView" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)setModel:(DayHistoryModel *)model
{
    self.motionLabel.text = model.step;
    self.aggressivenessLabel.text = model.aggressiveness;
    self.motionTargetLabel.text = model.stepTarget;
    self.sumSleepLabel.text = model.sumSleep;
    self.deepSleepLabel.text = model.deepSleep;
    self.lowSleepLabel.text = model.lowSleep;
    self.winLabel.text = model.win;
    self.drawLabel.text = model.draw;
    self.failLabel.text = model.fail;
    self.PKCountLabel.text = model.PKCount;
}

@end
