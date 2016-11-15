//
//  OPMainContentView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientLabel.h"

@interface OPMainContentView : UIView

@property (nonatomic ,weak) UIImageView *backGroundImageView;

@property (nonatomic ,weak) GradientLabel *moneyLabel;
@property (nonatomic ,weak) GradientLabel *stepLabel;
@property (nonatomic ,weak) GradientLabel *sleepLabel;
@property (nonatomic ,weak) GradientLabel *aggressivenessLbael;
@property (nonatomic ,weak) UILabel *failCountLabel;
@property (nonatomic ,weak) UILabel *successCountLabel;
@property (nonatomic ,weak) UILabel *drawCountLabel;
@property (nonatomic ,weak) UILabel *PKCountLabel;

@property (nonatomic ,weak) UIButton *musicButton;
@property (nonatomic ,weak) UIButton *photoButton;
@property (nonatomic ,weak) UIButton *syncButton;
@property (nonatomic ,weak) UIButton *PKButton;

@end
