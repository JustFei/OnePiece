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
@property (nonatomic ,strong) UITextField *oldPwdTextField;
@property (nonatomic ,strong) UITextField *nPwdTextField;   //newPwdTextField，不能如此命名，所以命名为nPwdTextField

@end
