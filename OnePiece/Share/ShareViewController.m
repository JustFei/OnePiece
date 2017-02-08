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



@interface ShareViewController () < UICollectionViewDelegate , UICollectionViewDataSource >


@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) UIImageView *backImageView;
@property (nonatomic ,strong) NSArray *photoArr;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    self.view.backgroundColor = kBackGroundColor;
    self.collectionView.backgroundColor = kWhiteColor;
    self.backImageView.backgroundColor = kClearColor;
    [self.backView bringSubviewToFront:self.moneyLabel];
    [self.backView bringSubviewToFront:self.userNameLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoThumbCell" forIndexPath:indexPath];
    UIImageView *thumbImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photoArr[indexPath.row]]];
    thumbImageView.frame = cell.bounds;
    [cell addSubview:thumbImageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        self.userNameLabel.hidden = YES;
        self.moneyLabel.hidden = YES;
    }else {
        self.userNameLabel.hidden = NO;
        self.moneyLabel.hidden = NO;
    }
    self.backImageView.image = [UIImage imageNamed:self.photoArr[indexPath.row]];
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.5, 32.5, 10.5, 32.5);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

#pragma mark - Action
- (void)dismissVCAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction:(UIButton *)sender
{
    
    UIImage *image = [self saveImage:self.backView];
    //UIImage *image = [self thumbnailWithImageWithoutScale:bigImage size:CGSizeMake(kControllerWidth, kControllerWidth)];
    
    //1、创建分享参数
    NSArray* imageArray = @[image];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:nil
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

#pragma mark - addImage
/**
 加半透明水印
 @param useImage 需要加水印的图片
 @param maskImage 水印
 @returns 加好水印的图片
 */
- (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage msakRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(maskImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    //四个参数为水印图片的位置
    [maskImage drawInRect:rect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//截屏的方式
-(UIImage *)saveImage:(UIView *)view {
    CGRect mainRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(CGSizeMake(self.backView.frame.size.width, self.backView.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    [[UIColor blackColor] set];
    
    CGContextFillRect(context, mainRect);
    [view.layer renderInContext:context];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:XXF_CGRectMake(0,64, kControllerWidth, kControllerHeight - 130 * kControllerWidth / 375)];
        [self.view addSubview:_backView];
    }
    
    return _backView;
}

- (MoveAbleImageView *)shareImageView
{
    if (!_shareImageView) {
        MoveAbleImageView *view = [[MoveAbleImageView alloc] initWithFrame:XXF_CGRectMake(0, 0, kControllerWidth, kControllerHeight - 152 * kControllerWidth / 375)];
        view.userInteractionEnabled = YES;
        [view setMultipleTouchEnabled:YES];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self.backView addSubview:view];
        _shareImageView = view;
    }
    
    return _shareImageView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //该方法也可以设置itemSize
        layout.itemSize = CGSizeMake(31 * kControllerWidth / 375, 44 * kControllerWidth / 375);
        
        //2.初始化collectionView
        UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:XXF_CGRectMake(0, self.backView.frame.origin.y + self.backView.frame.size.height, kControllerWidth, kControllerHeight - (self.backView.frame.origin.y + self.backView.frame.size.height)) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photoThumbCell"];
        
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    
    return _collectionView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(0, 0, kControllerWidth, kControllerHeight - 130 * kControllerWidth / 375)];
        view.image = [UIImage imageNamed:self.photoArr[0]];
        [self.backView addSubview:view];
        _backImageView = view;
    }
    
    return _backImageView;
}

- (NSArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = @[@"Photo1",@"Photo2",@"Photo3",@"Photo4",@"Photo5",@"Photo6",@"Photo7",@"Photo8",@"Photo9",@"Photo10",];
    }
    
    return _photoArr;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:XXF_CGRectMake(kControllerCenter.x - 122 * kControllerWidth / 375, self.backView.frame.size.height * 1685 / 2208, 245 * kControllerWidth / 375, 75 * kControllerWidth / 375)];
        label.text = @"Name";
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Vani" size:40 * kControllerWidth / 375];
//        label.font = [UIFont fontWithName:@"Vani" size:14 * kControllerWidth / 375];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kUIColorFromHEX(0x423433, 1);
        [self.backView addSubview:label];
        _userNameLabel = label;
    }
    
    return _userNameLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:XXF_CGRectMake(kControllerCenter.x - 122 * kControllerWidth / 375, self.backView.frame.size.height * 918 / 1074, 245 * kControllerWidth / 375, 40 * kControllerWidth / 375)];
        label.text = @"0";
        label.font = [UIFont fontWithName:@"Vrinda" size: 35 * kControllerWidth / 375];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = kUIColorFromHEX(0x423433, 1);
        [self.backView addSubview:label];
        _moneyLabel = label;
    }
    
    return _moneyLabel;
}

@end
