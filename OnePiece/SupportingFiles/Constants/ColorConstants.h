//
//  ColorConstants.h
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#ifndef ColorConstants_h
#define ColorConstants_h

// rgb颜色转换（16进制->10进制）
#define kUIColorFromHEX(rgbValue ,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//带有RGBA的颜色设置
#define kUIColorFromRGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//清除背景色
#define kClearColor [UIColor clearColor]

//常用颜色
#define kWhiteColor [UIColor whiteColor]
#define kBlackColor [UIColor blackColor]
#define kRedColor [UIColor redColor]
#define kBlueColor [UIColor blueColor]
#define kGreenColor [UIColor greenColor]
#define kGrayColor [UIColor grayColor]
#define kOrangeColor [UIColor orangeColor]
#define kPurpleColor [UIColor purpleColor]

//通用的背景颜色
#define kBackGroundColor kUIColorFromHEX(0xf2f2f2, 1)

//navigationBar 的颜色
#define kNavigationBarColor kUIColorFromHEX(0xfabe00, 1)

//tableView 线的颜色
#define kLineColor kUIColorFromHEX(0xcccccc,1)

#endif /* ColorConstants_h */
