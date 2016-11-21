//
//  AboutContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "AboutContentView.h"
#import "FeedBackViewController.h"

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
    self.appIcon.backgroundColor = kRedColor;
    [self addSubview:self.appIcon];
    
    self.versionLabel = [[UILabel alloc] initWithFrame:XXF_CGRectMake(kViewCenter.x - 60, self.appIcon.frame.origin.y + 140, 120, 15)];
    self.versionLabel.textColor = kBlackColor;
    self.versionLabel.font = [UIFont systemFontOfSize:17];
    self.versionLabel.text = [@"版本 " stringByAppendingString:app_Version];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.versionLabel];
    
    self.tableView.frame = XXF_CGRectMake(0, 235 + 64, kViewWidth, 106);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //1.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.设置当前上下问路径
    //设置起始点
    CGContextMoveToPoint(context, kViewCenter.x - 137.5, 215 + 64);
    //增加点
    CGContextAddLineToPoint(context, kViewCenter.x + 137.5, 215 + 64);
    //关闭路径
    CGContextClosePath(context);
    //3.设置属性
    /*
     UIKit会默认导入 core Graphics框架，UIKit对常用的很多的唱歌方法做了封装
     UIColor setStroke设置边线颜色
     uicolor setFill 设置填充颜色
     
     */
    [kBlackColor setStroke];
    [[UIColor blueColor] setFill];
    //    [[UIColor yellowColor]set];
    //4.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
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
        cell.textLabel.text = @"使用帮助";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        FeedBackViewController *vc = [[FeedBackViewController alloc] init];
        [[self findViewController:self].navigationController pushViewController:vc animated:YES];
    }else {
        
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
