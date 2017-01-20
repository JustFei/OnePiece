//
//  GradientLabel.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "GradientLabel.h"

@implementation GradientLabel

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void) setDirectionStart:(CGPoint)start
                      end:(CGPoint) end {
    startPoint = start;
    endPoint = end;
    self.customDirection = YES;
}

-(void) setGradientStartColor: (UIColor*)startColor
                     endColor: (UIColor*)endColor{
    CGFloat red1 = 0.0;
    CGFloat green1 = 0.0;
    CGFloat blue1 = 0.0;
    CGFloat alpha1 = 0.0;
    CGFloat red2 = 0.0;
    CGFloat green2 = 0.0;
    CGFloat blue2 = 0.0;
    CGFloat alpha2 = 0.0;
    [startColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [endColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    CGFloat colors[] =
    {red1, green1, blue1, alpha1, red2, green2, blue2, alpha2};
    memcpy(gradientColors, colors, 8 * sizeof (CGFloat));
    self.drawGradient = YES;
}

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    // Draw the text without an outline
    [super drawTextInRect:rect];
    
    CGImageRef alphaMask = NULL;
    
    if ([self drawGradient]) {
        // Create a mask from the text
        alphaMask = CGBitmapContextCreateImage(context);
        
        // clear the image
        CGContextClearRect(context, rect);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, rect.size.height);
        
        // invert everything because CoreGraphics works with an inverted coordinate system
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // Clip the current context to our alphaMask
        CGContextClipToMask(context, rect, alphaMask);
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColors, NULL, 2);
        CGColorSpaceRelease(baseSpace), baseSpace = NULL;
        
        if (!self.customDirection) {
            startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        }
        
        // Draw the gradient
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
    }
    
    if ([self drawOutline]) {
        // Create a mask from the text (with the gradient)
        alphaMask = CGBitmapContextCreateImage(context);
        
        // Outline width
        CGContextSetLineWidth(context, self.outlineThickness);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        // Set the drawing method to stroke
        CGContextSetTextDrawingMode(context, kCGTextStroke);
        
        // Outline color
        UIColor *tmpColor = self.textColor;
        self.textColor = [self outlineColor];
        
        // notice the +1 for the y-coordinate. this is to account for the face that the outline appears to be thicker on top
        [super drawTextInRect:CGRectMake(rect.origin.x, rect.origin.y+1, rect.size.width, rect.size.height)];
        
        // Draw the saved image over the outline
        // and invert everything because CoreGraphics works with an inverted coordinate system
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, rect, alphaMask);
        
        // Clean up because ARC doesnt handle CG
        CGImageRelease(alphaMask);
        
        // restore the original color
        self.textColor = tmpColor;
    }
}

@end
