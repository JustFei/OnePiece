//
//  MenuContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/15.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MenuContentView.h"

@interface MenuContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,weak) UIImageView *headImageView;
@property (nonatomic ,weak) UILabel *nameLabel;
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *logOutButton;
@property (nonatomic ,strong) NSArray *cellImageArr;
@property (nonatomic ,strong) NSArray *cellNameArr;

@end

@implementation MenuContentView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellImageArr = @[@"User",@"Setting",@"About"];
        self.cellNameArr = @[@"用户",@"设置",@"关于"];
    }
    return self;
}

- (void)layoutSubviews
{
    self.headImageView.frame = XXF_CGRectMake(kViewCenter.x - 55, 12.5, 110, 110);
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.layer.borderColor = kBlackColor.CGColor;
    self.headImageView.layer.borderWidth = 1;
    
    
    self.nameLabel.frame = XXF_CGRectMake(kViewCenter.x - 80, 142.5, 160, 16);
    UIView *cutView = [[UIView alloc] initWithFrame:XXF_CGRectMake(kViewCenter.x - 137.5, 178.5, 275, 1)];
    cutView.backgroundColor = kUIColorFromHEX(0xcccccc, 1);
    [self addSubview:cutView];
    
    self.tableView.frame = XXF_CGRectMake(0, cutView.frame.origin.y + 21, kViewWidth, 159);
    
    self.logOutButton.frame = XXF_CGRectMake(kViewCenter.x - 50, self.tableView.frame.origin.y + 259, 100, 40);
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.cellImageArr[indexPath.row]];
    cell.textLabel.text = self.cellNameArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CGRect rect = cell.imageView.frame;
    CGSize size = CGSizeMake(12, 12);
    rect.size = size;
    
    cell.imageView.frame = rect;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark - 懒加载
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HeadImage"]];
        
        [self addSubview:view];
        _headImageView = view;
    }
    
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"乔巴";
        label.textColor = kBlackColor;
        label.font = [UIFont systemFontOfSize:25.5];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        _nameLabel = label;
    }
    
    return _nameLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource = self;
        [view registerClass:[UITableViewCell self] forCellReuseIdentifier:@"menuCell"];
        
        [self addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (UIButton *)logOutButton
{
    if (!_logOutButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"登出" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [button setTitleColor:kUIColorFromHEX(0x0076ff, 1) forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x00a0e9, 1) forState:UIControlStateHighlighted];
        
        [self addSubview:button];
        _logOutButton = button;
    }
    
    return _logOutButton;
}

@end