//
//  DayDataView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayHistoryModel.h"

@interface DayDataView : UICollectionViewCell

/*
 注意：
 这里要指出，以后这种布局还是不要用xib的好！！！
 为了使每行数据的间距可以适应屏幕宽度
 这里添加了一些站位用的view
 可参考这篇帖子：http://blog.csdn.net/sophia_xiaoma/article/details/50803214
 */

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

@property (nonatomic ,strong) DayHistoryModel *model;

@end
