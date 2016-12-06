//
//  ChangePwdContentView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopViewController)(void);

@interface ChangePwdContentView : UIView

@property (nonatomic ,copy) PopViewController popViewController;

@end
