//
//  AboutContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "AboutContentView.h"
#import "FeedBackViewController.h"
#import "ConnectUsViewController.h"

@interface AboutContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,strong) UIImageView *appIcon;
@property (nonatomic ,strong) UILabel *versionLabel;
@property (nonatomic ,weak) UITableView *tableView;

@end

@implementation AboutContentView

- (void)layoutSubviews
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.appIcon = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(kViewCenter.x - 60, 50 + 64, 120, 120)];
//    self.appIcon.backgroundColor = kRedColor;
    self.appIcon.image = [UIImage imageNamed:@"AboutIcon"];
    [self addSubview:self.appIcon];
    
    self.versionLabel = [[UILabel alloc] initWithFrame:XXF_CGRectMake(kViewCenter.x - 60, self.appIcon.frame.origin.y + 140, 120, 15)];
    self.versionLabel.textColor = kBlackColor;
    self.versionLabel.font = [UIFont systemFontOfSize:17];
    self.versionLabel.text = [@"版本 " stringByAppendingString:app_Version];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.versionLabel];
    
    self.tableView.frame = XXF_CGRectMake(0, 235 + 64, kViewWidth, 107);
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"反馈";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"联系我们";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            FeedBackViewController *vc = [[FeedBackViewController alloc] init];
            [[self findViewController:self].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ConnectUsViewController *vc = [[ConnectUsViewController alloc] init];
            [[self findViewController:self].navigationController pushViewController:vc animated:YES];
        }
            
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [view registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"aboutCell"];
        view.scrollEnabled = NO;
        view.backgroundColor = kUIColorFromHEX(0xffffff, 1);
        view.separatorColor = kUIColorFromHEX(0xcccccc, 1);
        view.delegate = self;
        view.dataSource = self;
        [self addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

#pragma mark - 获取当前View的控制器的方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


@end
