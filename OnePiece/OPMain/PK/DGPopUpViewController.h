//
//  DGPopUpViewController.h
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/17.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#define DGPopUpViewBackgroundColor [[UIColor colorWithRed: 245 / 255.f green: 245 / 255.f blue: 245 / 255.f alpha: 1] colorWithAlphaComponent: 0.8]

#import <UIKit/UIKit.h>
#import "DGPopUpView.h"

@interface DGPopUpViewController : UIViewController
@property (nonatomic, strong) DGPopUpView *popUpView;
- (void) showInView: (UIView *)aView animated: (BOOL)animated;

@end
