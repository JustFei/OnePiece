//
//  DayHistoryModel.h
//  OnePiece
//
//  Created by JustFei on 2016/12/7.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayHistoryModel : NSObject

@property (nonatomic ,copy) NSString *step;
@property (nonatomic ,copy) NSString *aggressiveness;
@property (nonatomic ,copy) NSString *stepTarget;
@property (nonatomic ,copy) NSString *sumSleep;
@property (nonatomic ,copy) NSString *deepSleep;
@property (nonatomic ,copy) NSString *lowSleep;
@property (nonatomic ,copy) NSString *win;
@property (nonatomic ,copy) NSString *draw;
@property (nonatomic ,copy) NSString *fail;
@property (nonatomic ,copy) NSString *PKCount;

@end
