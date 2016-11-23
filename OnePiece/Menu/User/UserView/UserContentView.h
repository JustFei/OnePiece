//
//  UserContentView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PickerTypeGender = 0,
    PickerTypeBirthday,
    PickerTypeHeight,
    PickerTypeWeight,
    PickerTypeMotionTarget
} PickerType;

@interface UserContentView : UIView

@end
