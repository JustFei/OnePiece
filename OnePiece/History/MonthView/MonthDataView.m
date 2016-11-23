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

@end
