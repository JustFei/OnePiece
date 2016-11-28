//
//  ShareViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = XXF_CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismissVCAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = XXF_CGRectMake(0, 0, 44, 44);
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    
    self.view.backgroundColor = kBackGroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)dismissVCAction:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareAction:(UIButton *)sender
{
    UIImage *image = [self thumbnailWithImageWithoutScale:self.shareImageView.image size:CGSizeMake(kControllerWidth, kControllerWidth)];
    //1、创建分享参数
    NSArray* imageArray = @[image];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://manridy.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
                               [alertController addAction:suerAction];
                               [self presentViewController:alertController animated:YES completion:nil];
                               
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                               [alertController addAction:suerAction];
                               [self presentViewController:alertController animated:YES completion:nil];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image)
        
    {
        
        newimage = nil;
        
    } else {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}

#pragma mark - 懒加载
- (UIImageView *)shareImageView
{
    if (!_shareImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:view];
        _shareImageView = view;
    }
    
    return _shareImageView;
}

@end
