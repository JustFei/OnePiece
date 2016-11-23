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

@end
