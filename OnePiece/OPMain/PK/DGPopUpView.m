//
//  DGPopUpView.m
//  DGPopUpViewController
//
//  Created by 段昊宇 on 16/6/18.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGPopUpView.h"

//#import "Masonry.h"

@interface DGPopUpView()

@property (nonatomic ,strong) UIImageView *backImageView;
@property (nonatomic ,strong) UIImageView *loadingImageView;
@property (nonatomic ,strong) UIImageView *baileyImage;
@property (nonatomic ,strong) UILabel *moneyResultLabel;
@property (nonatomic ,strong) NSArray *pkResultArr;
@property (nonatomic ,strong) NSArray *moneyArr;
@property (nonatomic ,assign) BOOL allowTouchClose;

@end

@implementation DGPopUpView

#pragma mark - Overide
- (instancetype) initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutIfNeeded];
        self.allowTouchClose = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(0.2, 0.2);
        
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.frame = frame;
        self.backImageView.image = [UIImage imageNamed:@"fight_bg"];
        [self addSubview:self.backImageView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.loadingImageView = [[UIImageView alloc] init];
            self.loadingImageView.center = self.center;
            CGRect rect = self.loadingImageView.frame;
            rect.size = CGSizeMake(self.bounds.size.width / 2.5, self.bounds.size.width / 2.5);
            self.loadingImageView.frame = rect;
            self.loadingImageView.center = self.center;
            self.loadingImageView.image = [UIImage imageNamed:@"fight_loading"];
            [self addSubview:self.loadingImageView];
            [self startAnimation:self.loadingImageView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.loadingImageView.layer removeAllAnimations];
                [self.loadingImageView setHidden: YES];
                
                //将背景图更换
                switch (self.pkResult) {
                    case PKResultTypeDraw:
                        self.backImageView.image = [UIImage imageNamed:@"draw"];
                        break;
                    case PKResultTypeWin:
                        self.backImageView.image = [UIImage imageNamed:@"win"];
                        break;
                    case PKResultTypeFail:
                        self.backImageView.image = [UIImage imageNamed:@"fail"];
                        break;
                        
                    default:
                        break;
                }
                
                //胜负平文本
//                CGRect rect = self.loadingImageView.frame;
//                rect.origin.y = rect.origin.y - 100;
                self.baileyImage.frame = CGRectMake(self.center.x - 13, 24, 26, 41);
                self.baileyImage.image = [UIImage imageNamed:@"bailey_pk"];
                //self.baileyImage.text = self.pkResultArr[self.pkResult];
                
                //金额文本
                self.moneyResultLabel.frame = CGRectMake(self.center.x - 150, 72.5, 300, 30);
                self.moneyResultLabel.text = self.moneyArr[self.pkResult];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.allowTouchClose = YES;
                });
                
            });
        });
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(closeAnimation)
                                                     name: @"NEXT_Button"
                                                   object: nil];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.allowTouchClose) {
        if (self.showNavigationItemBlock) {
            self.showNavigationItemBlock ();
        }
        [self closeAnimation];
    }
}

- (instancetype) init {
//    self = [self initWithFrame: CGRectMake(0, 0, 320, 480)];
    return self;
}

#pragma mark - Layout
//- (void) setlayout {
//    self.loginButton.frame = CGRectMake(0, self.frame.size.height - self.loginButton.frame.size.height, self.loginButton.frame.size.width, self.loginButton.frame.size.height);
//    
//    self.textView.frame = CGRectMake(0, 80, 320, 60);
//    self.textView_2.frame = CGRectMake(0, 160, 320, 60);
//    self.textView_3.frame = CGRectMake(0, 240, 320, 60);
//}

#pragma mark - Close Animation
- (void) closeAnimation {
    self.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration: 0.6
                          delay: 0.3
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations: ^{
                         self.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         self.superview.alpha = 1;
                     }
                     completion: ^(BOOL finished) {
                         [[NSNotificationCenter defaultCenter] postNotificationName: @"end_animation" object: nil];
                         [self removeFromSuperview];
                     }];
    
}

#pragma mark - 图片旋转
- (void)startAnimation:(UIImageView *)imageView
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
//    return imageView;
}

#pragma mark - 懒加载
- (UIImageView *)baileyImage
{
    if (!_baileyImage) {
        _baileyImage = [[UIImageView alloc] init];
        _baileyImage.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_baileyImage];
    }
    
    return _baileyImage;
}

- (UILabel *)moneyResultLabel
{
    if (!_moneyResultLabel) {
        _moneyResultLabel = [[UILabel alloc] init];
        _moneyResultLabel.font = [UIFont fontWithName:@"Baoli SC" size:35];
        _moneyResultLabel.textAlignment = NSTextAlignmentCenter;
        _moneyResultLabel.textColor = kUIColorFromHEX(0xedf50c, 1);
        [self addSubview:_moneyResultLabel];
    }
    
    return _moneyResultLabel;
}

- (NSArray *)pkResultArr
{
    if (!_pkResultArr) {
        _pkResultArr = @[@"平",@"胜",@"负"];
    }
    
    return _pkResultArr;
}

- (NSArray *)moneyArr
{
    if (!_moneyArr) {
        _moneyArr = @[@"+5000",@"+10000",@"-10000"];
    }
    
    return _moneyArr;
}


@end
