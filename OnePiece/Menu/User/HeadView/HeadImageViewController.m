//
//  HeadImageViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "HeadImageViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

@interface HeadImageViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate >

@property (nonatomic ,weak) UIImageView *bigHeadImageView;
@property (nonatomic ,strong) BmobQuery *bquery;
@property (nonatomic ,strong) BmobObject *obj;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation HeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBlackColor;
    self.bigHeadImageView.backgroundColor = kBlackColor;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"];
        [self.bigHeadImageView setImage:[UIImage imageWithData:imageData]];
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = XXF_CGRectMake(0, 0, 100, 40);
    [rightButton setTitle:@"换头像" forState:UIControlStateNormal];
    [rightButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(changeHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //查找UserModel
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    [self.bquery whereKey:@"account" equalTo:account];
    [self.bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //没有返回错误
        if (!error) {
            //对象存在
            if (array) {
                self.obj = array.firstObject;
            }
        }else{
            //进行错误处理
        }
    }];
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
    [self.bigHeadImageView setImage:[self thumbnailWithImageWithoutScale:newPhoto size:CGSizeMake(kControllerWidth, kControllerWidth)]];
    NSData *imageData = UIImagePNGRepresentation(self.bigHeadImageView.image);
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud.label setText:@"正在同步头像。。。"];
    
    BmobFile *file = [[BmobFile alloc] initWithFileName:@"userHeadImage.png" withFileData:imageData];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        //如果文件保存成功，则把文件添加到filetype列
        if (isSuccessful){
            [self.obj setObject:file forKey:@"userIcon"];
//            [self.obj setObject:file.url forKey:@"userIcon"];
            [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self.hud.label setText:[NSString stringWithFormat:@"头像已同步完成"]];
                    [self.hud hideAnimated:YES afterDelay:1];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self.hud.label setText:[NSString stringWithFormat:@"头像同步失败，请重试"]];
                    [self.hud hideAnimated:YES afterDelay:1];
                }
            }];
            //打印file文件的url地址
            DLog(@"file url %@",file.url);
        } else {
            //进行处理
            DLog(@"%@",error);
            [self.hud.label setText:[NSString stringWithFormat:@"头像同步失败，请重试"]];
            [self.hud hideAnimated:YES afterDelay:1];
        }
    }];
    
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userHeadImage"];
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

- (BmobQuery *)bquery
{
    if (!_bquery) {
        _bquery = [BmobQuery queryWithClassName:@"UserModel"];
    }
    
    return _bquery;
}

@end
