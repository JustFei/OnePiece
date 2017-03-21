//
//  PKTool.m
//  OnePiece
//
//  Created by JustFei on 2016/12/13.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "PKTool.h"

@implementation PKTool

/*关于比拼逻辑，暂定如下：
 1：霸气值为0，则胜率为0,平率为0,败率为100%
 2：霸气值为0-200，则胜率为10%,平率为10%,败率为80%
 3：霸气值为200-700，胜率为30%,平率为30%,败率为40%
 4：霸气值为700-1000，胜率为50%,平率为30%,败率为20%
 5：霸气值为1000+，胜率为60%,平率为20%,败率为20%
 0：平，1：胜，2：负
 */

/*
 3.21更新比拼胜率表（暂未考虑平局）
 霸气值	    获胜概率
 [0, 100)	1%
 [100, 200)	2%
 [200, 300)	3%
 [300, 400)	4%
 [400, 500)	5%
 [500, 600)	6%
 [600, 700)	7%
 [700, 800)	8%
 [800, 900)	9%
 [900, 1k)	10%
 [1k, 2k)	20%
 [2k, 3k)	30%
 [3k, 5k)	40%
 [5k, 1w)	50%
 [1w, 1.5w)	60%
 [1.5w, 2w)	70%
 [2w, 2.5w)	80%
 [2.5w, 3w)	85%
 [3w,  4w)	90%
 [4w, ∞)	95%
 0：平，1：胜，2：负
 */
+ (NSInteger)getPKResultWithAggressiveness:(float)aggressiveness
{
    int value = (arc4random() % 100) + 1;
    //1：霸气值为0，则胜率为0,平率为0,败率为100%
    if (aggressiveness >= 0 && aggressiveness < 100) {
        if (value == 1) {
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 100 && aggressiveness < 200) {
        if (value <= 2) {                                           
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 200 && aggressiveness < 300) {
        if (value <= 3) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 300 && aggressiveness < 400) {
        if (value <= 4) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 400 && aggressiveness < 500) {
        if (value <= 5) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 500 && aggressiveness < 600) {
        if (value <= 6) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 600 && aggressiveness < 700) {
        if (value <= 7) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 700 && aggressiveness < 800) {
        if (value <= 8) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 800 && aggressiveness < 900) {
        if (value <= 9) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 900 && aggressiveness < 1000) {
        if (value <= 10) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 1000 && aggressiveness < 2000) {
        if (value <= 20) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 2000 && aggressiveness < 3000) {
        if (value <= 30) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 3000 && aggressiveness < 5000) {
        if (value <= 40) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 5000 && aggressiveness < 10000) {
        if (value <= 50) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 10000 && aggressiveness < 15000) {
        if (value <= 60) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 15000 && aggressiveness < 20000) {
        if (value <= 70) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 20000 && aggressiveness < 25000) {
        if (value <= 80) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 25000 && aggressiveness < 30000) {
        if (value <= 85) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 30000 && aggressiveness < 40000) {
        if (value <= 90) {                                            
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness >= 40000) {
        if (value <= 95) {
            return 1;
        }else {
            return 2;
        }
    }
    
    return 5;
}

@end
