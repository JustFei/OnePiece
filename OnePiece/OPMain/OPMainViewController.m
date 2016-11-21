//
//  OPMainViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "OPMainViewController.h"
#import "OPMainContentView.h"
#import "MenuViewController.h"

@interface OPMainViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate >

@property (nonatomic ,strong) OPMainContentView *contentView;

@end

@implementation OPMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = kClearColor;
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 21, 21);
    [leftButton setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pushMenuList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 21, 21);
    [rightButton setImage:[UIImage imageNamed:@"History"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(pushHistoryView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setTintColor:kBlackColor];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //跳转到分享界面
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma makr - Action
- (void)pushMenuList
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHistoryView
{
    
}

- (void)musicAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)cameraAction:(UIButton *)sender
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

- (void)syncAction:(UIButton *)sender
{
    
}

- (void)PKAction:(UIButton *)sender
{
    
}

#pragma mark - 懒加载
- (OPMainContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[OPMainContentView alloc] initWithFrame:self.view.bounds];
        _contentView.backGroundImageView.backgroundColor = [UIColor whiteColor];
        [_contentView.musicButton addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.photoButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.syncButton addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.PKButton addTarget:self action:@selector(PKAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_contentView];
    }
    
    return _contentView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
