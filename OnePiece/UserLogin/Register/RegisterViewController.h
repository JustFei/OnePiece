//
//  RegisterViewController.h
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoginTypeRegister = 0,
    LoginTypeResetPwd
} LoginType;

@interface RegisterViewController : UIViewController

@property (nonatomic ,assign) LoginType loginType;

@end
