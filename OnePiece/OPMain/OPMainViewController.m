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
#import "HistoryViewController.h"
#import "ShareViewController.h"
#import "BLETool.h"
#import "FMDBTool.h"
#import "NSStringTool.h"
#import "manridyBleDevice.h"

@interface OPMainViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate , BleDiscoverDelegate , BleReceiveDelegate , BleConnectDelegate >
{
    BOOL _isBind;
    NSString *_currentDateString;
    float _stepAngry;
    float _sleepAngry;
}

@property (nonatomic ,strong) OPMainContentView *contentView;
@property (nonatomic ,strong) BLETool *myBleTool;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) NSArray *userArr;

@end

@implementation OPMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isBind = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBind"];
    DLog(@"有没有绑定设备 == %d",_isBind);
    
    [self createUI];
    
    [self bleConnect];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *currentDate = [NSDate date];
    _currentDateString = [formatter stringFromDate:currentDate];
    
    [self getDataFromDB];
    
    self.navigationController.navigationBar.barTintColor = kClearColor;
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.userArr = nil;
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

- (void)getDataFromDB
{
    //先展示数据库里的数据
    //步数
    NSArray *stepArr = [self.myFmdbTool queryStepWithDate:_currentDateString];
    if (stepArr.count) {
        SportModel *sportModel = stepArr.lastObject;
        self.contentView.stepLabel.text = sportModel.stepNumber;
        [self drawProgressWithString:sportModel.stepNumber.floatValue withType:ReturnModelTypeSportModel];
        _stepAngry = sportModel.stepNumber.integerValue / 10 * 0.5;
    }
    
    //睡眠
    NSArray *sleepArr = [self.myFmdbTool querySleepWithDate:_currentDateString];
    if (sleepArr.count) {
        double sum = 0;
        for (SleepModel *sleepModel in sleepArr) {
            sum += sleepModel.sumSleep.doubleValue / 60;
        }
        self.contentView.sleepLabel.text = [NSString stringWithFormat:@"%.1f",sum];
        [self drawProgressWithString:sum withType:ReturnModelTypeSleepModel];
        _sleepAngry = _stepAngry * (sum / 8.f) * 0.5;
    }
    [self.contentView.aggressivenessLbael setText:[NSString stringWithFormat:@"%.f",_sleepAngry + _stepAngry]];
    //pk数据
    NSArray *pkDataArr = [self.myFmdbTool queryPKDataWithData:_currentDateString];
    if (pkDataArr.count != 0) {
        PKModel *pkModel = pkDataArr.firstObject;
        self.contentView.winCountLabel.text = pkModel.win;
        self.contentView.drawCountLabel.text = pkModel.draw;
        self.contentView.failCountLabel.text = pkModel.fail;
        self.contentView.PKCountLabel.text = [NSString stringWithFormat:@"比拼%@次",pkModel.PKCount];
    }else {
        self.contentView.winCountLabel.text = @"0";
        self.contentView.drawCountLabel.text = @"0";
        self.contentView.failCountLabel.text = @"0";
        self.contentView.PKCountLabel.text = @"比拼0次";
    }
}

- (void)bleConnect
{
    //监听state变化的状态
    [self.myBleTool addObserver:self forKeyPath:@"systemBLEstate" options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"监听到%@对象的%@属性发生了改变， %@", object, keyPath, change[@"new"]);
    if ([keyPath isEqualToString:@"systemBLEstate"]) {
        NSString *new = change[@"new"];
        switch (new.integerValue) {
            case 4:
                
                break;
            case 5:
            {
                if (_isBind) {
                    if (self.myBleTool.connectState == kBLEstateDisConnected) {
                        [self connectBLE];
                    }
                }
            }
                
                break;
                
            default:
                break;
        }
    }
}

- (void)connectBLE
{
    BOOL systemConnect = [self.myBleTool retrievePeripherals];
    if (!systemConnect) {
        [self.myBleTool scanDevice];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.myBleTool stopScan];
            
            if (self.myBleTool.connectState == kBLEstateDisConnected) {
//                [self.mainVc.stepView.stepLabel setText:@"未连接上设备，点击重试"];
            }
        });
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //跳转到分享界面
    ShareViewController *vc = [[ShareViewController alloc] init];
    vc.shareImageView.image = newPhoto;
    vc.shareImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BleDiscoverDelegate
- (void)manridyBLEDidDiscoverDeviceWithMAC:(manridyBleDevice *)device
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralMac"]) {
        NSString *macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralMac"];
        if ([device.macAddress isEqualToString:macAddress]) {
            [self.myBleTool connectDevice:device];
        }
    }
}

#pragma mark - BleConnectDelegate
- (void)manridyBLEDidConnectDevice:(manridyBleDevice *)device
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self syncAction:nil];
    });
    
}

#pragma mark - BleReceiveDelegate
//motion data
- (void)receiveMotionDataWithModel:(manridyModel *)manridyModel
{
    if (manridyModel.isReciveDataRight) {
        if (manridyModel.receiveDataType == ReturnModelTypeSportModel) {
            //保存motion数据到数据库
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"yyyy/MM/dd"];
            NSDate *currentDate = [NSDate date];
            NSString *currentDateString = [dateformatter stringFromDate:currentDate];
            
            switch (manridyModel.sportModel.motionType) {
                case MotionTypeStep:
                    //对获取的步数信息做操作
                    break;
                case MotionTypeStepAndkCal:
                {
                    [self.contentView.stepLabel setText:manridyModel.sportModel.stepNumber];
                    [self drawProgressWithString:manridyModel.sportModel.stepNumber.floatValue withType:ReturnModelTypeSportModel];
                    
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSArray *stepArr = [self.myFmdbTool queryStepWithDate:manridyModel.sportModel.date];
                        if (stepArr.count == 0) {
                            [self.myFmdbTool insertStepModel:manridyModel.sportModel];
                        }else {
                            [self.myFmdbTool modifyStepWithDate:manridyModel.sportModel.date model:manridyModel.sportModel];
                        }
                    });
                }
                    break;
                case MotionTypeCountOfData:
                    //对历史数据个数进行操作
                    break;
                case MotionTypeDataInPeripheral:
                {
                    if (manridyModel.sportModel.sumDataCount != 0 && manridyModel.sportModel.sumDataCount) {
                        //对具体的历史数据进行保存操作
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            NSArray *stepArr = [self.myFmdbTool queryStepWithDate:manridyModel.sportModel.date];
                            float height;float weight;
                            _userArr = [self.myFmdbTool queryAllUserInfo];
                            if (_userArr.count == 0) {
                                weight = 75.0;
                                height = 180.0;
                            }else {
                                //这里由于是单用户，所以取第一个值
                                UserInfoModel *model = _userArr.firstObject;
                                weight = model.weight;
                                height = model.height;
                            }
                            manridyModel.sportModel.kCalNumber = [NSString stringWithFormat:@"%f",[NSStringTool getKcal:manridyModel.sportModel.stepNumber.integerValue withHeight:height andWeitght:weight]];
                            manridyModel.sportModel.mileageNumber = [NSString stringWithFormat:@"%f",[NSStringTool getMileage:manridyModel.sportModel.stepNumber.integerValue withHeight:height]];
                            
                            if (stepArr.count == 0) {
                                [self.myFmdbTool insertStepModel:manridyModel.sportModel];
                            }else {
                                [self.myFmdbTool modifyStepWithDate:currentDateString model:manridyModel.sportModel];
                            }
                            
                            if (manridyModel.sportModel.sumDataCount == manridyModel.sportModel.currentDataCount + 1) {
                                [self.myBleTool writeMotionRequestToPeripheralWithMotionType:MotionTypeStepAndkCal];
                            }
                            
                        });
                    }else {
                        [self.myBleTool writeMotionRequestToPeripheralWithMotionType:MotionTypeStepAndkCal];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

//get sleepInfo
- (void)receiveSleepInfoWithModel:(manridyModel *)manridyModel
{
    @autoreleasepool {
        if (manridyModel.isReciveDataRight) {
            if (manridyModel.receiveDataType == ReturnModelTypeSleepModel) {
                
                //如果历史数据，插入数据库
                if (manridyModel.sleepModel.sleepState == SleepDataHistoryData) {
                    NSDate *currentDate = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy/MM/dd";
                    NSString *currentDateString = [formatter stringFromDate:currentDate];
                    
                    //如果历史数据总数不为空
                    if (manridyModel.sleepModel.sumDataCount) {
                        
                        //插入历史睡眠数据，如果sumCount为0的话，就不做保存
                        [self.myFmdbTool insertSleepModel:manridyModel.sleepModel];
                        
                        //如果历史数据全部载入完成
                        if (manridyModel.sleepModel.currentDataCount + 1 == manridyModel.sleepModel.sumDataCount) {
                            [self querySleepDataBaseWithDateString:currentDateString];
                        }
                    }else {
                        //这里不查询历史，直接查询数据库展示即可
                        [self querySleepDataBaseWithDateString:currentDateString];
                    }
                }else {
                    [self.myBleTool writeSleepRequestToperipheral:SleepDataHistoryData];
                }
            }
        }
    }
}

#pragma mark - DataBase
- (void)querySleepDataBaseWithDateString:(NSString *)currentDateString
{
    @autoreleasepool {
        //当历史数据查完并存储到数据库后，查询数据库当天的睡眠数据，并加入数据源
        NSArray *sleepDataArr = [self.myFmdbTool querySleepWithDate:currentDateString];
        if (sleepDataArr.count != 0) {
            double sum = 0;
            for (SleepModel *model in sleepDataArr) {
                sum += model.sumSleep.doubleValue / 60;
            }
            self.contentView.sleepLabel.text = [NSString stringWithFormat:@"%.1f",sum];
            [self drawProgressWithString:sum withType:ReturnModelTypeSleepModel];
        }
    }
}

#pragma mark - Action
- (void)pushMenuList
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHistoryView
{
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    //1.同步时间
    [self.myBleTool writeTimeToPeripheral:[NSDate date]];
    //2.同步运动历史
    [self.myBleTool writeMotionRequestToPeripheralWithMotionType:MotionTypeDataInPeripheral];
    //3.同步睡眠历史
    [self.myBleTool writeSleepRequestToperipheral:SleepDataHistoryData];
}

- (void)PKAction:(UIButton *)sender
{
    
}

- (void)drawProgressWithString:(float)sum withType:(ReturnModelType)type
{
    if (type == ReturnModelTypeSportModel) {
        //TODO:绘制步数进度条
        UserInfoModel *model = self.userArr.firstObject;
        float progress = sum / model.stepTarget;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentView.stepProgress.curValue = progress * 100;
        });
        
    }else if (type == ReturnModelTypeSleepModel) {
        //TODO:绘制睡眠进度条
        float progress = sum / 8.f;
        DLog(@"睡眠进度 == %f",progress);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentView.sleepProgress.curValue = progress * 100;
        });
    }
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

- (BLETool *)myBleTool
{
    if (!_myBleTool) {
        _myBleTool = [BLETool shareInstance];
        _myBleTool.discoverDelegate = self;
        _myBleTool.connectDelegate = self;
        _myBleTool.receiveDelegate = self;
    }
    
    return _myBleTool;
}

- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    
    return _myFmdbTool;
}

- (NSArray *)userArr
{
    if (!_userArr) {
        _userArr = [self.myFmdbTool queryAllUserInfo];
    }
    
    return _userArr;
}

@end
