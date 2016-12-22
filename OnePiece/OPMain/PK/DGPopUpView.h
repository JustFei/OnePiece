//
//  DGPopUpView.h
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/18.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PKResultTypeDraw = 0,
    PKResultTypeWin,
    PKResultTypeFail
} PKResultType;

@interface DGPopUpView : UIView

@property (nonatomic ,assign) PKResultType pkResult;

@end
