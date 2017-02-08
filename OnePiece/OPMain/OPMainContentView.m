//
//  OPMainContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "OPMainContentView.h"


@interface OPMainContentView ()

@end

@implementation OPMainContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (void)layoutSubviews
{
    self.frame = [UIScreen mainScreen].bounds;
    
    //背景图片
    self.backGroundImageView.frame = kViewFrame;
    //金币label
    self.moneyLabel.frame = XXF_CGRectMake(kViewCenter.x - 100, 81.5 * kViewWidth / 375, 200, 35 * kViewWidth / 375);
    self.moneyLabel.backgroundColor = kClearColor;
    //步数label
    self.stepLabel.frame = XXF_CGRectMake(10, 75, 100, 22);
    //睡眠label
    self.sleepLabel.frame = XXF_CGRectMake(kViewWidth - 116, 75, 100, 22);
    //步数(脚丫)图片
    UIImageView *stepImageView = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(16, self.stepLabel.frame.origin.y + 23.5, 25, 34)];
    stepImageView.image = [UIImage imageNamed:@"Step"];
    [self addSubview:stepImageView];
    //睡眠(zzz)图片
    UIImageView *sleepImageView = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(kViewWidth - 47, self.sleepLabel.frame.origin.y + 26.5, 28, 28)];
    sleepImageView.image = [UIImage imageNamed:@"Sleep"];
    [self addSubview:sleepImageView];
    //音乐按钮
    self.musicButton.frame = CGRectMake(15, kViewHeight * 870 / 1334 - 44, 35, 35);
    //拍照按钮
    self.photoButton.frame = CGRectMake(kViewWidth - 50, self.musicButton.frame.origin.y, 35, 35);
    //同步按钮
    self.syncButton.frame = CGRectMake(15, self.musicButton.frame.origin.y + 59 * kViewHeight / 667, 102 * kViewHeight / 667, 18.5 * kViewHeight / 667);
    //PK按钮
    self.PKButton.frame = CGRectMake(kViewWidth - 117 * kViewHeight / 667, self.syncButton.frame.origin.y, self.syncButton.frame.size.width, self.syncButton.frame.size.height);
    //步数进度条
    self.stepProgress = [[MAThermometer alloc] initWithFrame:XXF_CGRectMake(10.5 + 17.5, stepImageView.frame.origin.y + 39 , 7, (self.musicButton.frame.origin.y - stepImageView.frame.origin.y - 45) * 375 / 460)];
    self.stepProgress.arrayColors = @[kRedColor,kOrangeColor];
    [self addSubview:self.stepProgress];
    //步数空槽
    UIImageView *stepEmptySlot = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(10.5, stepImageView.frame.origin.y + 35, 40, self.musicButton.frame.origin.y - stepImageView.frame.origin.y - 45)];
    stepEmptySlot.image = [UIImage imageNamed:@"EmptySlot"];
    [self addSubview:stepEmptySlot];
    //睡眠进度条
    self.sleepProgress = [[MAThermometer alloc] initWithFrame:XXF_CGRectMake(kViewWidth - 33    , self.stepProgress.frame.origin.y, 7, self.stepProgress.frame.size.height)];
    self.sleepProgress.arrayColors = @[kBlueColor,kPurpleColor];
    [self addSubview:self.sleepProgress];
    UIImageView *sleepEmptySlot = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(kViewWidth - 50.5, stepEmptySlot.frame.origin.y, 40, self.musicButton.frame.origin.y - stepImageView.frame.origin.y - 45)];
    sleepEmptySlot.image = [UIImage imageNamed:@"EmptySlot"];
    [self addSubview:sleepEmptySlot];
    
    self.aggressivenessLbael.frame = CGRectMake(kViewCenter.x - 200, kViewHeight - 170 * kViewWidth / 375, 400, 65);
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewCenter.x - 8.5, kViewHeight - 58 * kViewHeight / 667 , 17, 7)];
    failLabel.text = @"败";
    [failLabel setFont:[UIFont fontWithName:@"Baoli SC" size:12]];
    failLabel.textAlignment = NSTextAlignmentCenter;
    [failLabel setTextColor:kWhiteColor];
    [self addSubview:failLabel];
    CGFloat failLabelX = failLabel.frame.origin.x;
    CGFloat failLabelY = failLabel.frame.origin.y;
    CGFloat failLabelW = failLabel.frame.size.width;
    CGFloat failLabelH = failLabel.frame.size.height;
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(failLabelX - 63 * kViewHeight / 667, failLabelY, failLabelW, failLabelH)];
    [successLabel setFont:[UIFont fontWithName:@"Baoli SC" size:12]];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.text = @"胜";
    [successLabel setTextColor:kWhiteColor];
    [self addSubview:successLabel];
    
    UILabel *drawLabel = [[UILabel alloc] initWithFrame:CGRectMake(failLabelX + 63 * kViewHeight / 667, failLabelY, failLabelW, failLabelH)];
    [drawLabel setFont:[UIFont fontWithName:@"Baoli SC" size:12]];
    drawLabel.textAlignment = NSTextAlignmentCenter;
    drawLabel.text = @"平";
    [drawLabel setTextColor:kWhiteColor];
    [self addSubview:drawLabel];
    
    self.failCountLabel.frame = CGRectMake(failLabel.center.x - 22.5, failLabelY - 30, 45, 25);
    CGFloat failCountLabelY = self.failCountLabel.frame.origin.y;
    CGFloat failCountLabelW = self.failCountLabel.frame.size.width;
    CGFloat failCountLbaelH = self.failCountLabel.frame.size.height;
    self.winCountLabel.frame = CGRectMake(successLabel.center.x - 22.5, failCountLabelY, failCountLabelW, failCountLbaelH);
    self.drawCountLabel.frame = CGRectMake(drawLabel.center.x - 22.5, failCountLabelY, failCountLabelW, failCountLbaelH);
    
    self.PKCountLabel.frame = CGRectMake(kViewCenter.x - 55 * kViewHeight / 667, failLabelY + failLabelH + 10, 110 * kViewHeight / 667, 20 * kViewHeight / 667);
    
    
    //打印字体用
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames )
//        {
            printf( "\tFont: %s \n", [familyName UTF8String] );
//        }
    }
}

#pragma mark - 懒加载
- (UIImageView *)backGroundImageView
{
    if (!_backGroundImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@"Main"];
        [self addSubview:view];
        _backGroundImageView = view;
    }
    
    return _backGroundImageView;
}

- (GradientLabel *)moneyLabel
{
    if (!_moneyLabel) {
        GradientLabel *label = [[GradientLabel alloc] initWithFrame:CGRectZero];
        label.text = @"0-";
        label.font = [UIFont fontWithName:@"BernardMT-Condensed" size:30 * kViewWidth / 375];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kUIColorFromHEX(0x884227,1);
        label.outlineColor = kUIColorFromHEX(0xc68107, 1);
        label.outlineThickness = 3;
        label.drawOutline = YES;
        [self addSubview:label];
        _moneyLabel = label;
    }
    
    return _moneyLabel;
}

- (GradientLabel *)stepLabel
{
    if (!_stepLabel) {
        GradientLabel *label = [[GradientLabel alloc] initWithFrame:CGRectZero];
        label.text = @"0";
        label.font = [UIFont fontWithName:@"Shunpu" size:27];
        label.textAlignment = NSTextAlignmentLeft;
        //label.textColor = kUIColorFromHEX(0xe06800, 1);
        label.textColor = kUIColorFromHEX(0xe06000, 1);
        label.outlineThickness = 1;
        label.outlineColor = kUIColorFromHEX(0x000000, 1);
        label.drawOutline = YES;
        //label.drawGradient = YES;
        [self addSubview:label];
        _stepLabel = label;
    }
    
    return _stepLabel;
}

- (GradientLabel *)sleepLabel
{
    if (!_sleepLabel) {
        GradientLabel *label = [[GradientLabel alloc] initWithFrame:CGRectZero];
        //这里7.5的间距很大，需要设置字间距来调整
        label.text = @"0";
        label.font = [UIFont fontWithName:@"Shunpu" size:27];
        label.textAlignment= NSTextAlignmentRight;
        label.textColor = kUIColorFromHEX(0xe06000, 1);
        label.outlineThickness = 1;
        label.outlineColor = kUIColorFromHEX(0x000000, 1);
        //label.drawGradient = YES;
        label.drawOutline = YES;
        [self addSubview:label];
        _sleepLabel = label;
    }
    
    return _sleepLabel;
}

- (GradientLabel *)aggressivenessLbael
{
    if (!_aggressivenessLbael) {
        GradientLabel *label = [[GradientLabel alloc] initWithFrame:CGRectZero];
        label.text = @"0";
        label.font = [UIFont fontWithName:@"Hakuu" size:70.5];
        label.textAlignment= NSTextAlignmentCenter;
        label.textColor = kUIColorFromHEX(0xe05d00, 1);
        [self addSubview:label];
        _aggressivenessLbael = label;
    }
    
    return _aggressivenessLbael;
}

- (UIButton *)musicButton
{
    if (!_musicButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = kClearColor;
        [button setImage:[UIImage imageNamed:@"Music"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Music_select"] forState:UIControlStateSelected];
        [button setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:button];
        _musicButton = button;
    }
    
    return _musicButton;
}

- (UIButton *)photoButton
{
    if (!_photoButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = kClearColor;
        [button setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Camera_select"] forState:UIControlStateSelected];
        [button setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:button];
        _photoButton = button;
    }
    
    return _photoButton;
}

- (UIButton *)syncButton
{
    if (!_syncButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Sync"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Sync_select"] forState:UIControlStateSelected];
        [button setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:button];
        _syncButton = button;
    }
    
    return _syncButton;
}

- (UIButton *)PKButton
{
    if (!_PKButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"PK"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"PK_select"] forState:UIControlStateSelected];
        [button setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:button];
        _PKButton = button;
    }
    
    return _PKButton;
}

- (UILabel *)failCountLabel
{
    if (!_failCountLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:kWhiteColor];
        [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:24]];
        [self addSubview:label];
        _failCountLabel = label;
    }
    
    return _failCountLabel;
}

- (UILabel *)winCountLabel
{
    if (!_winCountLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:kWhiteColor];
        [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:24]];
        [self addSubview:label];
        _winCountLabel = label;
    }
    
    return _winCountLabel;
}

- (UILabel *)drawCountLabel
{
    if (!_drawCountLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:kWhiteColor];
        [label setFont:[UIFont fontWithName:@"Chalkboard SE" size:24]];
        [self addSubview:label];
        _drawCountLabel = label;
    }
    
    return _drawCountLabel;
}

- (UILabel *)PKCountLabel
{
    if (!_PKCountLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"比拼0次";
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont fontWithName:@"Baoli SC" size:15]];
        [label setTextColor:kWhiteColor];
        [self addSubview:label];
        _PKCountLabel = label;
    }
    
    return _PKCountLabel;
}

@end
