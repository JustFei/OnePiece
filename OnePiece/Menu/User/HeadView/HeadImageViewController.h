//
//  HeadImageViewController.h
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseHeadImage)(UIImage *);

@interface HeadImageViewController : UIViewController
{
    BOOL isLoatServer;
}

@property (nonatomic ,strong) ChooseHeadImage chooseHeadImage;
@property (nonatomic ,strong) NSString *accountString;


@end
