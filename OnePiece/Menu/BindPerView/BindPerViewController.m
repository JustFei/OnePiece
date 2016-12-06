//
//  BindPerViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/29.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "BindPerViewController.h"
#import "BLETool.h"
#import "FMDBTool.h"
#import "manridyBleDevice.h"
#import "MBProgressHUD.h"
#import "OPMainViewController.h"
#import <BmobSDK/Bmob.h>

@interface BindPerViewController () < UITableViewDelegate , UITableViewDataSource , BleDiscoverDelegate , BleConnectDelegate >

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *bindButton;
@property (nonatomic ,strong) NSMutableArray *perMutArr;
@property (nonatomic ,strong) BLETool *myBleTool;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) manridyBleDevice *currentDevice;
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic ,strong) BmobQuery *bquery;

@end

@implementation BindPerViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.myBleTool = [BLETool shareInstance];
        self.myBleTool.discoverDelegate = self;
        self.myBleTool.connectDelegate = self;
        
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        self.myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    self.perMutArr = [NSMutableArray array];
    self.tableView.backgroundColor = kBackGroundColor;
    
    [self.myBleTool scanDevice];
    self.bindButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.navigationItem.title = @"绑定手环";
    self.view.backgroundColor = kBackGroundColor;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = XXF_CGRectMake(0, 0, 44, 44);
    [rightButton setTitle:@"刷新" forState:UIControlStateNormal];
    [rightButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Action
- (void)refreshTableView:(UIButton *)sender
{
    self.bindButton.enabled = NO;
    self.currentDevice = nil;
    [self deletAllRowsAtTableView];
    [self.myBleTool scanDevice];
}

- (void)disBindPeripheral
{
    self.myBleTool.isReconnect = NO;
    [self.myBleTool unConnectDevice];
    
    //查找GameScore表里面account的数据
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    [self.bquery whereKey:@"account" equalTo:account];
    [self.bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //没有返回错误
        if (!error) {
            //对象存在
            if (array) {
                for (BmobObject *obj in array) {
                    [obj setObject:@"0" forKey:@"peripheralName"];
                    [obj setObject:@"0" forKey:@"bindPeripheralUUID"];
                    [obj setObject:@"0" forKey:@"peripheralMac"];
                    [obj setObject:@"0" forKey:@"isBind"];
                    [obj updateInBackground];
                }
            }
        }else{
            //进行错误处理
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindPeripheralUUID"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindPeripheralName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindPeripheralMac"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isBind"];
}

- (void)bindPeripheral:(UIButton *)sender
{
    if (self.currentDevice) {
        [self.myBleTool connectDevice:self.currentDevice];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self.hud.label setText:@"正在连接设备..."];
        [self.myBleTool stopScan];
        [self.bindButton setEnabled:NO];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - BleDiscoverDelegate
- (void)manridyBLEDidDiscoverDeviceWithMAC:(manridyBleDevice *)device
{
    if (![self.perMutArr containsObject:device]) {
        [self.perMutArr addObject:device];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.perMutArr.count - 1 inSection:0];
        [indexPaths addObject: indexPath];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - BleConnectDelegate
- (void)manridyBLEDidConnectDevice:(manridyBleDevice *)device
{
    self.myBleTool.isReconnect = YES;
    [self.myBleTool writeTimeToPeripheral:[NSDate date]];
    
    //查找GameScore表里面account的数据
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    [self.bquery whereKey:@"account" equalTo:account];
    [self.bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //没有返回错误
        if (!error) {
            //对象存在
            if (array) {
                for (BmobObject *obj in array) {
                    [obj setObject:device.peripheral.name forKey:@"peripheralName"];
                    [obj setObject:device.uuidString forKey:@"bindPeripheralUUID"];
                    [obj setObject:device.macAddress forKey:@"peripheralMac"];
                    [obj setObject:@"1" forKey:@"isBind"];
                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }
                    }];
                }
            }
        }else{
            //进行错误处理
        }
    }];
    
    [self.hud.label setText:[NSString stringWithFormat:@"已绑定设备：%@",device.deviceName]];
    [self.hud hideAnimated:YES afterDelay:1];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    model.peripheralName = device.deviceName;
    model.peripheralMac = device.macAddress;
    [self.myFmdbTool modifyUserInfoModel:model  withModityType:UserInfoModifyTypePeripheralName];
    [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypePeripheralMac];
    
    [[NSUserDefaults standardUserDefaults] setObject:device.uuidString forKey:@"bindPeripheralUUID"];
    [[NSUserDefaults standardUserDefaults] setObject:device.deviceName forKey:@"bindPeripheralName"];
    [[NSUserDefaults standardUserDefaults] setObject:device.macAddress forKey:@"bindPeripheralMac"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isBind"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.returnMain) {
            OPMainViewController *vc = [[OPMainViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)manridyBLEDidFailConnectDevice:(manridyBleDevice *)device
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.hud.label setText:@"连接异常，请靠近设备再次尝试！"];
    [self.hud hideAnimated:YES afterDelay:1];
    
    [self deletAllRowsAtTableView];
    [self.bindButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.perMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bindCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"bindCell"];
    }
    manridyBleDevice *device = self.perMutArr[indexPath.row];
    
    cell.textLabel.text = device.deviceName;
    cell.textLabel.textColor = kLineColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentDevice = self.perMutArr[indexPath.row];
    cell.textLabel.textColor = kBlackColor;
    self.bindButton.enabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = kLineColor;
}

- (void)deletAllRowsAtTableView
{
    //移除cell
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int row = 0; row < self.perMutArr.count; row ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [indexPaths addObject:indexPath];
    }
    [self.perMutArr removeAllObjects];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:XXF_CGRectMake(0, 74, kControllerWidth, kControllerHeight - 64 - 59) style:UITableViewStylePlain];
        view.tableFooterView = [[UIView alloc] init];
        
        view.delegate = self;
        view.dataSource = self;
        
        [self.view addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (UIButton *)bindButton
{
    if (!_bindButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = XXF_CGRectMake(0, kControllerHeight - 49, kControllerWidth, 49);
        [button setImage:[UIImage imageNamed:@"Bind_enable"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Bind_unEnable"] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(bindPeripheral:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        _bindButton = button;
    }
    
    return _bindButton;
}

- (BmobQuery *)bquery
{
    if (!_bquery) {
        _bquery = [BmobQuery queryWithClassName:@"UserModel"];
    }
    
    return _bquery;
}

@end
