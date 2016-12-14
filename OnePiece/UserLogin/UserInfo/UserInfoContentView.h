//
//  UserInfoContentView.h
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface UserInfoContentView : UIView

@property (nonatomic ,strong) UserInfoModel *userModel;
@property (nonatomic ,weak) UITableView *tableView;

@end
