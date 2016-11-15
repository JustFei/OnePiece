//
//  GradientLabel.h
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientLabel : UILabel
{
    CGFloat gradientColors[8];
    CGPoint startPoint;
    CGPoint endPoint;
}

@property BOOL drawOutline;
@property (strong, nonatomic) UIColor *outlineColor;
@property (nonatomic) CGFloat outlineThickness;

@property BOOL drawGradient;
-(void) setGradientStartColor: (UIColor*)startColor
                     endColor: (UIColor*)endColor;

@property BOOL customDirection;
-(void) setDirectionStart:(CGPoint)start
                      end:(CGPoint)end;

@end
