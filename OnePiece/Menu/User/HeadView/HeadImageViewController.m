//
//  HeadImageViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "HeadImageViewController.h"

@interface HeadImageViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate >

@property (nonatomic ,weak) UIImageView *bigHeadImageView;

@end

@implementation HeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBlackColor;
    self.bigHeadImageView.backgroundColor = kRedColor;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userheadimage"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userheadimage"];
        [self.bigHeadImageView setImage:[UIImage imageWithData:imageData]];
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = XXF_CGRectMake(0, 0, 100, 40);
    [rightButton setTitle:@"换头像" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(changeHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //把newPhono设置成头像
    [self.bigHeadImageView setImage:newPhoto];
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSData *imageData = UIImagePNGRepresentation(self.bigHeadImageView.image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userheadimage"];
}

#pragma mark - Action
- (void)changeHeadImage:(UIButton *)sender
{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//方式1
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方方式3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;//方式1
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIImageView *)bigHeadImageView
{
    if (!_bigHeadImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(0, 146, kControllerWidth, kControllerWidth)];
        [self.view addSubview:view];
        _bigHeadImageView = view;
    }
    
    return _bigHeadImageView;
}

@end
