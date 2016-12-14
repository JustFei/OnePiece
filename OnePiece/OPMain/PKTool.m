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
+ (NSInteger)getPKResultWithAggressiveness:(float)aggressiveness
{
    int value = (arc4random() % 100) + 1;
    //1：霸气值为0，则胜率为0,平率为0,败率为100%
    if (aggressiveness == 0) {
        return 2;
    }else if (aggressiveness >0 && aggressiveness <= 200) {       //2：霸气值为0-200，则胜率为10%,平率为10%,败率为80%
        if (value <= 10) {
            return 0;
        }else if (value >10 && value <= 20){
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness > 200 && aggressiveness <= 700) {        //3：霸气值为200-700，胜率为30%,平率为30%,败率为40%
        if (value <= 30) {
            return 0;
        }else if (value > 30 && value <= 60) {
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness > 700 && aggressiveness <= 1000) {       //4：霸气值为700-1000，胜率为50%,平率为30%,败率为20%
        if (value <= 30) {
            return 0;
        }else if (value > 30 && value <= 80) {
            return 1;
        }else {
            return 2;
        }
    }else if (aggressiveness > 1000) {        //5：霸气值为1000+，胜率为60%,平率为20%,败率为20%
        if (value <= 20) {
            return 0;
        }else if (value > 20 && value <= 80) {
            return 1;
        }else {
            return 2;
        }
    }
    
    return 5;
}

@end
