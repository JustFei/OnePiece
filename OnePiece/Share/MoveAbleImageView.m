//
//  MoveAbleImageView.m
//  OnePiece
//
//  Created by JustFei on 2016/12/15.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MoveAbleImageView.h"

@interface MoveAbleImageView ()
{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
}
@end

@implementation MoveAbleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addGestureRecognizerToView];
        oldFrame = self.frame;
        largeFrame = CGRectMake(0 - self.frame.size.width, 0 - self.frame.size.height, 2 * oldFrame.size.width, 2 * oldFrame.size.height);
    }
    return self;
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    float dX = [[touches anyObject] locationInView:self].x - [[touches anyObject] previousLocationInView:self].x;
    float dY = [[touches anyObject] locationInView:self].y - [[touches anyObject] previousLocationInView:self].y;
    //CGAffineTransformTranslate 是以transform为起点
    self.transform = CGAffineTransformTranslate(self.transform, dX, dY);
}
*/
 
// 添加所有的手势
- (void) addGestureRecognizerToView
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    //    sender.view.transform = CGAffineTransformMake(cos(M_PI_4), sin(M_PI_4), -sin(M_PI_4), cos(M_PI_4), 0, 0);
    //捏合手势两种改变方式
    //以原来的位置为标准
    //    sender.view.transform = CGAffineTransformMakeRotation(sender.rotation);//rotation 是旋转角度
    
    //两个参数,以上位置为标准
    rotationGestureRecognizer.view.transform = CGAffineTransformRotate(rotationGestureRecognizer.view.transform, rotationGestureRecognizer.rotation);
    //消除增量
    rotationGestureRecognizer.rotation = 0.0;
    
#if 0
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
#endif
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    
    //scale 缩放比例
    //    sender.view.transform = CGAffineTransformMake(sender.scale, 0, 0, sender.scale, 0, 0);
    //每次缩放以原来位置为标准
    //    sender.view.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    
    //每次缩放以上一次为标准
    pinchGestureRecognizer.view.transform = CGAffineTransformScale(pinchGestureRecognizer.view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    //重新设置缩放比例 1是正常缩放.小于1时是缩小(无论何种操作都是缩小),大于1时是放大(无论何种操作都是放大)
    pinchGestureRecognizer.scale = 1;
    if (self.frame.size.width < oldFrame.size.width) {
        oldFrame.origin = self.frame.origin;
        self.frame = oldFrame;
        //让图片无法缩得比原图小
    }
    if (self.frame.size.width > 2 * oldFrame.size.width) {
        self.frame = largeFrame;
    }
    
//#if 0
//    UIImageView *imageView = (UIImageView *)pinchGestureRecognizer.view;
//    if (!imageView) {
//        return ;
//    }
//    //通过 transform(改变) 进行视图的视图的捏合
//    imageView.transform = CGAffineTransformScale(imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//    if (self.frame.size.width < oldFrame.size.width) {
//        oldFrame.origin = self.frame.origin;
//        self.frame = oldFrame;
//        //让图片无法缩得比原图小
//    }
//    if (self.frame.size.width > 2 * oldFrame.size.width) {
//        self.frame = largeFrame;
//    }
//    //设置比例 为 1
//    pinchGestureRecognizer.scale = 1;
//#endif
//    
//#if 0
//    UIView *view = pinchGestureRecognizer.view;
//    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        if (self.frame.size.width < oldFrame.size.width) {
//            self.frame = oldFrame;
//            //让图片无法缩得比原图小
//        }
//        if (self.frame.size.width > 3 * oldFrame.size.width) {
//            self.frame = largeFrame;
//        }
//        pinchGestureRecognizer.scale = 1;
//    }
//#endif
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIImageView *imageView = (UIImageView *)panGestureRecognizer.view;
    if (!imageView) {
        return ;
    }
    //获取手势的位置
    CGPoint position =[panGestureRecognizer translationInView:imageView];
    
    //通过stransform 进行平移交换
    imageView.transform = CGAffineTransformTranslate(imageView.transform, position.x, position.y);
    //将增量置为零
    [panGestureRecognizer setTranslation:CGPointZero inView:imageView];
    
//    UIView *view = panGestureRecognizer.view;
//    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
//        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
//        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
//    }
}



@end
