//
//  NetworkTool.m
//  OnePiece
//
//  Created by JustFei on 2016/12/13.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }

    return isExistenceNetwork;
}

@end
