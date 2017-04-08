//
//  SportModel.h
//  ManridyBleDemo
//
//  Created by 莫福见 on 16/9/12.
//  Copyright © 2016年 Manridy.Bobo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MotionTypeStep = 0,
    MotionTypeStepAndkCal,
    MotionTypeCountOfData,
    MotionTypeDataInPeripheral,
} MotionType;

typedef enum : NSUInteger {
    //上报类型
    GetDataTypeReport = 0,
    GetDataTypeTake,
} GetDataType;

@interface SportModel : NSObject

@property (nonatomic ,copy) NSString *stepNumber;
@property (nonatomic ,copy) NSString *mileageNumber;
@property (nonatomic ,copy) NSString *kCalNumber;
@property (nonatomic ,assign) NSInteger sumDataCount;
@property (nonatomic ,assign) NSInteger currentDataCount;
@property (nonatomic ,copy) NSString *date;
@property (nonatomic ,assign) MotionType motionType;
@property (nonatomic ,assign) GetDataType getType;

@end
