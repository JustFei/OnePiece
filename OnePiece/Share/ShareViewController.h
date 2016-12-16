//
//  ShareViewController.h
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveAbleImageView.h"
#import "GradientLabel.h"

@interface ShareViewController : UIViewController

@property (nonatomic ,strong) UILabel *userNameLabel;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,weak) MoveAbleImageView *shareImageView;

@end
