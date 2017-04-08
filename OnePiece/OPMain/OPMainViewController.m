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
#import "PKTool.h"
#import "NSStringTool.h"
#import "manridyBleDevice.h"
#import <BmobSDK/Bmob.h>
#import "NetworkTool.h"
#import "MBProgressHUD.h"
#import "DGPopUpViewController.h"

@interface OPMainViewController () < UINavigationControllerDelegate, UIImagePickerControllerDelegate , BleDiscoverDelegate , BleReceiveDelegate , BleConnectDelegate >
{
    BOOL _isBind;
    NSString *_todayString;
    NSString *_yestodayString;
    float _stepAngry;
    float _sleepAngry;
}

@property (nonatomic ,strong) OPMainContentView *contentView;
@property (nonatomic ,strong) BLETool *myBleTool;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) NSArray *userArr;
@property (nonatomic ,strong) NSArray *stepArr;
@property (nonatomic ,strong) NSArray *sleepArr;
@property (nonatomic ,strong) NSArray *pkDataArr;
@property (nonatomic ,strong) BmobQuery *bquery;
@property (strong, nonatomic) DGPopUpViewController *popUpViewController;

@end

@implementation OPMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.myFmdbTool deleteUserInfoData:nil];
    
    _isBind = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBind"];
    DLog(@"有没有绑定设备 == %d",_isBind);
    
    [self createUI];
    
    [self bleConnect];
    
    self.contentView.musicButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH"];
    NSString *hour = [formatter1 stringFromDate:date];
    NSInteger hourInt = [hour integerValue];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy/MM/dd"];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    if (hourInt < 9) {
        _todayString = [formatter1 stringFromDate:[[NSDate date] dateByAddingTimeInterval:-24 * 60 * 60]];
        _yestodayString = [formatter1 stringFromDate:[[NSDate date] dateByAddingTimeInterval:-48 * 60 * 60]];
    }else {
        _todayString = [formatter1 stringFromDate:[NSDate date]];
        _yestodayString = [formatter1 stringFromDate:[[NSDate date] dateByAddingTimeInterval:-24 * 60 * 60 ]];
    }
    
    [self getDataFromDB];
    
    self.navigationController.navigationBar.barTintColor = kClearColor;
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
    
    if (self.myBleTool.connectState == kBLEstateDidConnected) {
        [self syncAction:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.userArr = nil;
    self.myBleTool = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncTime"]) {
        NSString *lastSyncTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncTime"];
        self.contentView.syncLabel.text = [NSString stringWithFormat:@"上次%@",lastSyncTime];
    }
    
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
    //步数 : 展示的是今天的数据
    self.stepArr = [self.myFmdbTool queryStepWithDate:_todayString];
    if (self.stepArr.count) {
        SportModel *sportModel = self.stepArr.lastObject;
        self.contentView.stepLabel.text = sportModel.stepNumber;
        [self drawProgressWithString:sportModel.stepNumber.floatValue withType:ReturnModelTypeSportModel];
    }
    
    //昨日步数 : 用于计算霸气值用
    NSArray *yestodayStepArr = [self.myFmdbTool queryStepWithDate:_yestodayString];
    if (yestodayStepArr.count) {
        SportModel *sportModel = yestodayStepArr.lastObject;
        _stepAngry = sportModel.stepNumber.integerValue * 0.8;
    }
    
    //睡眠 : 09:00前展示的是昨天的数据
    //      09:00后展示的是今天的数据
    self.sleepArr = [self.myFmdbTool querySleepWithDate:_todayString];
    if (self.sleepArr.count) {
        double sum = 0;
        for (SleepModel *sleepModel in self.sleepArr) {
            sum += sleepModel.sumSleep.doubleValue / 60;
        }
        self.contentView.sleepLabel.text = [NSString stringWithFormat:@"%.1f",sum];
        [self drawProgressWithString:sum withType:ReturnModelTypeSleepModel];
    }
    
    //昨日睡眠 : 用于计算霸气值用
    NSArray *yestodaySleepArr = [self.myFmdbTool querySleepWithDate:_yestodayString];
    if (yestodaySleepArr.count) {
        double sum = 0;
        for (SleepModel *sleepModel in yestodaySleepArr) {
            sum += sleepModel.sumSleep.doubleValue / 60;
        }
        _sleepAngry = _stepAngry * (sum / 8.f) * 0.2;
    }
    
    [self.contentView.aggressivenessLbael setText:[NSString stringWithFormat:@"%.f",_sleepAngry + _stepAngry]];
    //pk数据
    self.pkDataArr = [self.myFmdbTool queryPKDataWithData:_todayString];
    if (self.pkDataArr.count != 0) {
        PKModel *pkModel = self.pkDataArr.firstObject;
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
    
    //money数据
    UserInfoModel *userModel = self.userArr.firstObject;
    self.contentView.moneyLabel.text = [NSString stringWithFormat:@"%@ - ",[NSStringTool countNumAndChangeformat:userModel.money]];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"BernardMT-Condensed" size:30 * kControllerWidth / 375],};
    CGSize textSize = [self.contentView.moneyLabel.text boundingRectWithSize:CGSizeMake(10000, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    CGRect rect = CGRectMake(self.contentView.frame.size.width / 2 - textSize.width / 2, 75 * kControllerWidth / 375, textSize.width, textSize.height);
    [self.contentView.moneyLabel setFrame:rect];
    //设置赏金图标的位置
    self.contentView.baileyView.frame = CGRectMake(rect.origin.x - 27, rect.origin.y, 25 * kControllerWidth / 375, 40 * kControllerWidth / 375);
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

- (void)dealloc
{
    [self.myBleTool removeObserver:self forKeyPath:@"systemBLEstate"];
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
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //跳转到分享界面
    ShareViewController *vc = [[ShareViewController alloc] init];
    vc.shareImageView.image = newPhoto;
    //money数据
    self.userArr = nil;
    UserInfoModel *userModel = self.userArr.firstObject;
    vc.moneyLabel.text = [NSString stringWithFormat:@"%@ - ",[NSStringTool countNumAndChangeformat:userModel.money]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BleDiscoverDelegate
- (void)manridyBLEDidDiscoverDeviceWithMAC:(manridyBleDevice *)device
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralMac"]) {
        NSString *macAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"peripheralMac"];
        if ([device.macAddress isEqualToString:macAddress] && ![macAddress isEqualToString:@""]) {
            [self.myBleTool connectDevice:device];
        }
    }
}

#pragma mark - BleConnectDelegate
- (void)manridyBLEDidConnectDevice:(manridyBleDevice *)device
{
    [self.myBleTool stopScan];
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
                    if (manridyModel.sportModel.stepNumber.integerValue % 100 == 0) {
                        [self getDataFromDB];
                    }else {
                        [self.contentView.stepLabel setText:manridyModel.sportModel.stepNumber];
                    }
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
                    if (manridyModel.sportModel.sumDataCount == manridyModel.sportModel.currentDataCount) {
                        [self.myBleTool writeMotionRequestToPeripheralWithMotionType:MotionTypeStepAndkCal];
                        DLog(@"feedback success current == %ld, sum == %ld", (long)manridyModel.sportModel.currentDataCount, (long)manridyModel.sportModel.sumDataCount);
                    }else {
                        DLog(@"motion current == %ld", (long)manridyModel.sportModel.currentDataCount);
                        [self.myBleTool writeMotionFeedBackToPeripheral:manridyModel.sportModel.currentDataCount + 1];
                        
                        //对具体的历史数据进行保存操作
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
                    
                    //如果历史数据总数不为空
                    if (manridyModel.sleepModel.sumDataCount != 0) {
                        if (manridyModel.sleepModel.sumDataCount == manridyModel.sleepModel.currentDataCount) {
                            [self querySleepDataBaseWithDateString:_yestodayString];
                            return;
                        }else {
                            DLog(@"sleep current == %ld", (long)manridyModel.sleepModel.currentDataCount + 1);
                            [self.myBleTool writeSleepFeedBackToPeripheral:manridyModel.sleepModel.currentDataCount + 1];
                        }
                        //插入历史睡眠数据，如果sumCount为0的话，就不做保存
                        [self.myFmdbTool insertSleepModel:manridyModel.sleepModel];
                    }else {
                        //这里不查询历史，直接查询数据库展示即可
                        [self querySleepDataBaseWithDateString:_yestodayString];
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
//            self.contentView.sleepLabel.text = [NSString stringWithFormat:@"%.1f",sum];
            //[self getDataFromDB];
            //[self drawProgressWithString:sum withType:ReturnModelTypeSleepModel];
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
        PickerImage.allowsEditing = NO;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;//通过相机
        PickerImage.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;//关闭闪光灯
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = NO;
        //代理
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
    if (self.myBleTool.connectState == kBLEstateDisConnected) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"设备尚未连接，无法同步数据";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        if (sender) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"数据正在同步中";
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
        }
        //1.同步时间
        [self.myBleTool writeTimeToPeripheral:[NSDate date]];
        //2.同步运动历史
        [self.myBleTool writeMotionRequestToPeripheralWithMotionType:MotionTypeDataInPeripheral];
        //3.同步睡眠历史
        [self.myBleTool writeSleepRequestToperipheral:SleepDataHistoryData];
        //修改同步时间Label的文字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSString *nowTime = [formatter stringFromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:@"lastSyncTime"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentView.syncLabel.text = [NSString stringWithFormat:@"上次%@",nowTime];
        });
    }
}

/*关于比拼逻辑，暂定如下：
 1：霸气值为0，则胜率为0,平率为0,败率为100%
 2：霸气值为0-200，则胜率为10%,平率为10%,败率为80%
 3：霸气值为200-700，胜率为30%,平率为30%,败率为40%
 4：霸气值为700-1000，胜率为50%,平率为30%,败率为20%
 5：霸气值为1000+，胜率为60%,平率为20%,败率为20%
 0：平，1：胜，2：负
 */
- (void)PKAction:(UIButton *)sender
{
    //判断网络状态
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        //隐藏掉UInavigationItem
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        
        self.popUpViewController = [[DGPopUpViewController alloc] init];
        self.popUpViewController.view.backgroundColor = kClearColor;
        [self.popUpViewController showInView:self.view animated:YES];
        
        self.userArr = nil;
        UserInfoModel *userModel = self.userArr.firstObject;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger value = [PKTool getPKResultWithAggressiveness:self.contentView.aggressivenessLbael.text.floatValue];
            self.popUpViewController.popUpView.pkResult = value;
            
            __weak OPMainViewController *weakSelf = self;
            //显示UInavigationItem
            self.popUpViewController.popUpView.showNavigationItemBlock = ^(void) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.navigationItem.leftBarButtonItem.customView.hidden = NO;
                    weakSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;

                });
                
            };
            switch (value) {
                case 1:
                    //胜
                {
                    NSInteger money = userModel.money.integerValue;
                    money += 10000;
                    if (money > 2000000000) {
                        money = 2000000000;
                    }
                    userModel.money = [NSString stringWithFormat:@"%ld",(long)money];
                    [self.myFmdbTool modifyUserInfoModel:userModel withModityType:UserInfoModifyTypeMoney];
                    if (self.pkDataArr.count != 0) {
                        PKModel *pkModel = self.pkDataArr.firstObject;
                        NSInteger win = pkModel.win.integerValue + 1;
                        NSInteger pkCount = pkModel.PKCount.integerValue + 1;
                        pkModel.PKCount = [NSString stringWithFormat:@"%ld",(long)pkCount];
                        pkModel.win = [NSString stringWithFormat:@"%ld", (long)win];
                        pkModel.date = _todayString;
                        [self.myFmdbTool modifyPKDataWithDate:_todayString model:pkModel];
                    }else {
                        PKModel *pkModel = [[PKModel alloc] init];
                        pkModel.win = @"1";
                        pkModel.fail = @"0";
                        pkModel.draw = @"0";
                        pkModel.PKCount = @"1";
                        pkModel.date = _todayString;
                        [self.myFmdbTool insertPKData:pkModel];
                    }
                }
                    break;
                case 2:
                    //负
                {
                    NSInteger money = userModel.money.integerValue;
                    money -= 10000;
                    if (money <= 0) {
                        money = 50;
                    }
                    userModel.money = [NSString stringWithFormat:@"%ld",(long)money];
                    [self.myFmdbTool modifyUserInfoModel:userModel withModityType:UserInfoModifyTypeMoney];
                    
                    if (self.pkDataArr.count != 0) {
                        PKModel *pkModel = self.pkDataArr.firstObject;
                        NSInteger fail = pkModel.fail.integerValue + 1;
                        pkModel.fail = [NSString stringWithFormat:@"%ld", (long)fail];
                        NSInteger pkCount = pkModel.PKCount.integerValue + 1;
                        pkModel.PKCount = [NSString stringWithFormat:@"%ld",(long)pkCount];
                        pkModel.date = _todayString;
                        [self.myFmdbTool modifyPKDataWithDate:_todayString model:pkModel];
                    }else {
                        PKModel *pkModel = [[PKModel alloc] init];
                        pkModel.fail = @"1";
                        pkModel.win = @"0";
                        pkModel.draw = @"0";
                        pkModel.PKCount = @"1";
                        pkModel.date = _todayString;
                        [self.myFmdbTool insertPKData:pkModel];
                    }
                }
                    
                    break;
                case 0:
                    //平
                {
                    NSInteger money = userModel.money.integerValue;
                    money += 5000;
                    if (money > 2000000000) {
                        money = 2000000000;
                    }
                    userModel.money = [NSString stringWithFormat:@"%ld",(long)money];
                    [self.myFmdbTool modifyUserInfoModel:userModel withModityType:UserInfoModifyTypeMoney];
                    
                    if (self.pkDataArr.count != 0) {
                        PKModel *pkModel = self.pkDataArr.firstObject;
                        NSInteger draw = pkModel.draw.integerValue + 1;
                        pkModel.draw = [NSString stringWithFormat:@"%ld", (long)draw];
                        NSInteger pkCount = pkModel.PKCount.integerValue + 1;
                        pkModel.PKCount = [NSString stringWithFormat:@"%ld",(long)pkCount];
                        pkModel.date = _todayString;
                        [self.myFmdbTool modifyPKDataWithDate:_todayString model:pkModel];
                    }else {
                        PKModel *pkModel = [[PKModel alloc] init];
                        pkModel.draw = @"1";
                        pkModel.win = @"0";
                        pkModel.fail = @"0";
                        pkModel.PKCount = @"1";
                        pkModel.date = _todayString;
                        [self.myFmdbTool insertPKData:pkModel];
                    }
                }
                    
                    break;
                    
                default:
                    break;
            }
            
            //查找UserModel表里面account的数据
            NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
            [self.bquery whereKey:@"account" equalTo:account];
            [self.bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                //没有返回错误
                if (!error) {
                    //对象存在
                    if (array) {
                        for (BmobObject *obj in array) {
                            [obj setObject:[NSNumber numberWithInt:userModel.money.intValue] forKey:@"money"];
                            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (error) {
                                    DLog(@"%@",error);
                                }
                            }];
                        }
                    }
                }else{
                    //进行错误处理
                    DLog(@"%@",error);
                }
            }];
            
            [self getDataFromDB];
            sender.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                sender.enabled = YES;
            });
        });
    }
}

- (void)drawProgressWithString:(float)sum withType:(ReturnModelType)type
{
    if (type == ReturnModelTypeSportModel) {
        //绘制步数进度条
        UserInfoModel *model = self.userArr.firstObject;
        float progress = sum / model.stepTarget;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.contentView.stepProgress.curValue = progress * 100;
        });
        
    }else if (type == ReturnModelTypeSleepModel) {
        //绘制睡眠进度条
        float progress = sum / 8.f;
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

- (BmobQuery *)bquery
{
    if (!_bquery) {
        _bquery = [BmobQuery queryWithClassName:@"UserModel"];
    }
    
    return _bquery;
}

@end
