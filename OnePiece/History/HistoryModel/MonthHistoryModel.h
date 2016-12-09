//
//  MonthHistoryModel.h
//  OnePiece
//
//  Created by JustFei on 2016/12/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthHistoryModel : NSObject

@property (nonatomic ,copy) NSString *averageStep;
@property (nonatomic ,copy) NSString *averageAggressiveness;
@property (nonatomic ,copy) NSString *averageSleep;
@property (nonatomic ,copy) NSString *monthWin;
@property (nonatomic ,copy) NSString *monthDraw;
@property (nonatomic ,copy) NSString *monthFail;
@property (nonatomic ,copy) NSString *monthPKCount;

@end
