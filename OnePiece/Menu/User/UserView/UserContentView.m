//
//  UserContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "UserContentView.h"
#import "UserTableViewCell.h"
#import "ChangeUserViewController.h"
#import "ChangePwdViewController.h"
#import "HeadImageViewController.h"
#import "FMDBTool.h"
#import <BmobSDK/Bmob.h>

@interface UserContentView () < UITableViewDelegate , UITableViewDataSource , UIPickerViewDelegate , UIPickerViewDataSource , UIActionSheetDelegate >

@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) NSMutableArray *infoArr;
@property (nonatomic ,strong) UILabel *nickName;
@property (nonatomic ,strong) UIPickerView *infoPickerView;
@property (nonatomic ,strong) UIDatePicker *datePickerView;
@property (nonatomic ,strong) NSArray *genderArr;
@property (nonatomic ,strong) NSArray *heightArr;
@property (nonatomic ,strong) NSArray *weightArr;
@property (nonatomic ,strong) NSArray *targetArr;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,assign) PickerType pickerType;
@property (nonatomic ,strong) UILabel *infoLabel;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) NSArray *userArr;
@property (nonatomic ,strong) BmobQuery *bquery;
@property (nonatomic ,strong) BmobObject *obj;

@end

@implementation UserContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        //self.titleArr = @[@[@"更改账号",@"更改密码",@"二维码"],@[@"头像",@"昵称"],@[@"性别",@"生日",@"身高",@"体重"],@[@"目标步数"]];
        self.titleArr = @[@[@"账号",@"更改密码"],@[@"头像",@"昵称"],@[@"性别",@"生日",@"身高",@"体重"],@[@"目标步数"]];
        UserInfoModel *model = self.userArr.lastObject;
        NSString *genderStr;
        switch (model.gender) {
            case -1:
                genderStr = @"未选择";
                break;
            case 0:
                genderStr = @"男";
                break;
            case 1:
                genderStr = @"女";
                break;
                
            default:
                break;
        }
        NSArray *arr = @[@[model.account,@"********",@""],@[@"",model.userName],@[genderStr,model.birthday,[NSString stringWithFormat:@"%ldcm",(long)model.height],[NSString stringWithFormat:@"%ldkg",(long)model.weight]],@[[NSString stringWithFormat:@"%ld",(long)model.stepTarget]]];
        self.infoArr = [NSMutableArray arrayWithArray:arr];
        
        //查找GameScore表里面account的数据
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
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 0, kViewWidth, kViewHeight);
}

#pragma mark - Action
- (void)showNameAlert
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"用户昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入昵称";
        textField.borderStyle = UITextBorderStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nickTextField = vc.textFields.firstObject;
        self.nickName.text = nickTextField.text;
        [[NSUserDefaults standardUserDefaults] setObject:nickTextField.text forKey:@"userName"];
        UserInfoModel *model = [[UserInfoModel alloc] init];
        model.userName = nickTextField.text;
        if (self.userArr.count) {
            
            [self.obj setObject:model.userName forKey:@"userName"];
            [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    DLog(@"%@",error);
                }else {
                    [self.myFmdbTool modifyUserInfoModel: model withModityType:UserInfoModifyTypeUserName];
                }
            }];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    okAction.enabled = NO;
    [vc addAction:cancleAction];
    [vc addAction:okAction];
    
    [[self findViewController:self] presentViewController:vc animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)[self findViewController:self].presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 0;
    }
}

- (void)showInfoPickerView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取到该cell的label对象，修改text
        if (self.title) {
            self.infoLabel.text = self.title;
            self.title = nil;
            UserInfoModel *model = [[UserInfoModel alloc] init];
            switch (self.pickerType) {
                case PickerTypeGender:
                {
                    if ([self.infoLabel.text isEqualToString:@"男"]) {
                        model.gender = 0;
                    }else if ([self.infoLabel.text isEqualToString:@"女"]) {
                        model.gender = 1;
                    }else if ([self.infoLabel.text isEqualToString:@"未选择"]) {
                        model.gender = -1;
                    }
                    [self.obj setObject:[NSNumber numberWithInt:model.gender] forKey:@"gender"];
                    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }else {
                            [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypeGender];
                        }
                    }];
                    
                }
                    break;
                case PickerTypeBirthday:
                {
                    model.birthday = self.infoLabel.text;
                    [self.obj setObject:model.birthday forKey:@"birthday"];
                    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }else {
                            [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypeBirthday];
                        }
                    }];
                    
                }
                    break;
                case PickerTypeHeight:
                {
                    model.height = self.infoLabel.text.integerValue;
                    [self.obj setObject:[NSNumber numberWithInt:model.height] forKey:@"height"];
                    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }else {
                            [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypeHeight];
                        }
                    }];
                }
                    break;
                case PickerTypeWeight:
                {
                    model.weight = self.infoLabel.text.integerValue;
                    [self.obj setObject:[NSNumber numberWithInt:model.weight] forKey:@"weight"];
                    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }else {
                            [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypeWeight];
                        }
                    }];
                    
                }
                    break;
                case PickerTypeMotionTarget:
                {
                    model.stepTarget = self.infoLabel.text.integerValue;
                    [self.obj setObject:[NSNumber numberWithInt:model.stepTarget] forKey:@"stepTarget"];
                    [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (error) {
                            DLog(@"%@",error);
                        }else {
                            [self.myFmdbTool modifyUserInfoModel:model withModityType:UserInfoModifyTypeStepTarget];
                        }
                    }];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    if (self.pickerType == PickerTypeBirthday) {
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:XXF_CGRectMake(0, 0, alert.view.frame.size.width - 30, 216)];
        self.datePickerView.tag = 1000;
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        [self.datePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        // 设置时区
        [self.datePickerView setTimeZone:[NSTimeZone localTimeZone]];
        // 设置当前显示时间
        [self.datePickerView setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [self.datePickerView setMaximumDate:[NSDate date]];
        // 设置UIDatePicker的显示模式
        [self.datePickerView setDatePickerMode:UIDatePickerModeDate];
        // 当值发生改变的时候调用的方法
        [self.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [alert.view addSubview:self.datePickerView];
    }else {
        self.infoPickerView = [[UIPickerView alloc] initWithFrame:XXF_CGRectMake(0, 0, alert.view.frame.size.width - 30, 216)];
        self.infoPickerView.dataSource = self;
        self.infoPickerView.delegate = self;
        self.infoPickerView.tag = 2000;
        [alert.view addSubview:self.infoPickerView];
    }
    
    [[self findViewController:self] presentViewController:alert animated:YES completion:nil];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    DLog(@"%@",datePicker.date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.title = [formatter stringFromDate:datePicker.date];
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource
// UIPickerViewDataSource中定义的方法，该方法的返回值决定改控件包含多少列

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    if (self.pickerType == PickerTypeBirthday) {
        return 3;
    }else {
        return 1;
    }
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少哥列表项

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case PickerTypeGender:
            return self.genderArr.count;
            break;
        case PickerTypeHeight:
            return self.heightArr.count;
            break;
        case PickerTypeWeight:
            return self.weightArr.count;
            break;
        case PickerTypeMotionTarget:
            return self.targetArr.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

// UIPickerViewDelegate中定义的方法，该方法返回NSString将作为UIPickerView中指定列和列表项上显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    switch (self.pickerType) {
        case PickerTypeGender:
            return self.genderArr[row];
            break;
        case PickerTypeWeight:
            return self.weightArr[row];
            break;
        case PickerTypeHeight:
            return self.heightArr[row];
            break;
        case PickerTypeMotionTarget:
            return [NSString stringWithFormat:@"%@",self.targetArr[row]];
            break;
            
        default:
            break;
    }
    return 0;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    switch (self.pickerType) {
        case PickerTypeGender:
            self.title = self.genderArr[row];
            break;
            
        case PickerTypeBirthday:
        {
            
        }
            break;
            
        case PickerTypeHeight:
            self.title = self.heightArr[row];
            break;
            
        case PickerTypeWeight:
            self.title = self.weightArr[row];
            break;
            
        case PickerTypeMotionTarget:
            self.title = [NSString stringWithFormat:@"%@", self.targetArr[row]];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    
    NSArray *titleArray = self.titleArr[indexPath.section];
    NSArray *infoArray = self.infoArr[indexPath.section];
    
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.titleLabel.textColor = kUIColorFromHEX(0x333333, 1);
    
    cell.infoLabel.text = infoArray[indexPath.row];
    cell.infoLabel.textColor = kUIColorFromHEX(0xcccccc, 1);
    
    cell.QRCodeImageView.hidden = YES;
    cell.headImageView.hidden = YES;
    switch (indexPath.section) {
        case 0:
        {
            //TODO:二维码
            /*
            if (indexPath.row == 2) {
                cell.QRCodeImageView.hidden = NO;
                cell.QRCodeImageView.image = [UIImage imageNamed:@"QRCodeImage_default"];
                //show QRCodeImage here
            }
             */
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.headImageView.hidden = NO;
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"]) {
                    NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"];
                    [cell.headImageView setImage:[UIImage imageWithData:imageData]];
                }else {
                    cell.headImageView.image = [UIImage imageNamed:@"HeadImage_default"];
                }
                cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
                cell.headImageView.layer.borderColor = kWhiteColor.CGColor;
                cell.headImageView.layer.borderWidth = 1;
                cell.headImageView.clipsToBounds = YES;
            }
            if (indexPath.row == 1) {
                self.nickName = cell.infoLabel;
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:XXF_CGRectMake(0, 0, kViewWidth, 20)];
    view.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else {
        return 20 * kViewWidth / 375;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.infoLabel = cell.infoLabel;
    switch (indexPath.section) {
            
        case 0:     //group 0
        {
            switch (indexPath.row) {
                case 0:
                {
                    //TODO:更改账号
                    //ChangeUserViewController *vc = [[ChangeUserViewController alloc] init];
                    //[[self findViewController:self].navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
                    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //show QRCode View
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 1:     //group 1
        {
            switch (indexPath.row) {
                case 0:
                {
                    HeadImageViewController *vc = [[HeadImageViewController alloc] init];
                    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    [self showNameAlert];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 2:     //group 2
        {
            
            switch (indexPath.row) {
                case 0:     //gender
                    self.pickerType = PickerTypeGender;
                    break;
                case 1:     //irthday
                    self.pickerType = PickerTypeBirthday;
                    break;
                case 2:     //height
                    self.pickerType = PickerTypeHeight;
                    break;
                case 3:     //weight
                    self.pickerType = PickerTypeWeight;
                    break;
                    
                default:
                    break;
            }
            
            [self showInfoPickerView];
        }
            break;
            
        case 3:     //group 3
        {
            self.pickerType =PickerTypeMotionTarget;
            [self showInfoPickerView];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
        view.tableFooterView = [[UIView alloc] init];
        
        view.delegate = self;
        view.dataSource = self;
        [view registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
        
        [self addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (NSArray *)genderArr
{
    if (!_genderArr) {
        _genderArr = @[@"未选择",@"男",@"女"];
    }
    return _genderArr;
}

- (NSArray *)heightArr
{
    if (!_heightArr) {
        NSMutableArray *heightMutArr = [NSMutableArray array];
        for (int i = 100; i <= 220; i ++) {
            NSString *height = [NSString stringWithFormat:@"%dcm",i];
            [heightMutArr addObject:height];
        }
        _heightArr = heightMutArr;
    }
    
    return _heightArr;
}

- (NSArray *)weightArr
{
    if (!_weightArr) {
        NSMutableArray *weightMutArr = [NSMutableArray array];
        for (int i = 30; i <= 150; i ++) {
            NSString *weight = [NSString stringWithFormat:@"%dkg",i];
            [weightMutArr addObject:weight];
        }
        _weightArr = weightMutArr;
    }
    
    return _weightArr;
}

- (NSArray *)targetArr
{
    if (!_targetArr) {
        NSMutableArray *targetMutArr = [NSMutableArray array];
        for (int i = 1000; i <= 50000; i = i + 1000) {
            [targetMutArr addObject:@(i)];
        }
        _targetArr = targetMutArr;
    }
    
    return _targetArr;
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

#pragma mark - 获取当前View的控制器的方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
