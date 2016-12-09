//
//  MonthDataView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthHistoryModel.h"

@interface MonthDataView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *avMotionLabel;
@property (weak, nonatomic) IBOutlet UILabel *avAggressivenessLabel;
@property (weak, nonatomic) IBOutlet UILabel *avSleepLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *drawLabel;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;
@property (weak, nonatomic) IBOutlet UILabel *PKCountLabel;

@property (nonatomic ,strong) MonthHistoryModel *model;

@end
