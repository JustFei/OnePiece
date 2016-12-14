//
//  FeedBackViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "FeedBackViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

@interface FeedBackViewController () < UITextViewDelegate >

@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,weak) UILabel *wordCountLabel;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView = [[UITextView alloc] initWithFrame:XXF_CGRectMake(0, 94, kControllerWidth, 200)];
    self.textView.editable = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = kBlackColor.CGColor;
    self.textView.delegate = self;
    self.textView.textColor = kBlackColor;
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.scrollEnabled = YES;
    [self.view addSubview:self.textView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kBackGroundColor;
    self.wordCountLabel.backgroundColor = kClearColor;
    
    self.navigationItem.title = @"反馈";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(feedBackAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)feedBackAction:(UIBarButtonItem *)item
{
    [self.textView resignFirstResponder];
    //提交反馈
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    //往UserModel表添
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud.label setText:@"正在连接设备..."];
    
    BmobObject *Feed_Back = [BmobObject objectWithClassName:@"Feed_Back"];
    [Feed_Back setObject:account forKey:@"account"];
    [Feed_Back setObject:self.textView.text forKey:@"FeedBack"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    [Feed_Back setObject:time forKey:@"time"];
    
    [Feed_Back saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        if (isSuccessful) {
            DLog(@"数据上传成功");
            [self.hud hideAnimated:YES afterDelay:2];
            [self.hud.label setText:@"反馈成功！感谢您的建议"];
            self.textView.text = @"";
        }else{
            [self.hud hideAnimated:YES afterDelay:2];
            [self.hud.label setText:@"反馈失败，请检查网络设置"];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    textView.layoutManager.allowsNonContiguousLayout = NO;
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 200) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 200 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.wordCountLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)200];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 200)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:200];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.wordCountLabel.text = [NSString stringWithFormat:@"%d/%d",MAX(0,200 - existTextNum),200];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UILabel *)wordCountLabel
{
    if (!_wordCountLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:XXF_CGRectMake(kControllerWidth - 70, self.textView.frame.origin.y + self.textView.frame.size.height + 20, 60, 20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"200/200";
        [self.view addSubview:label];
        _wordCountLabel = label;
    }
    
    return _wordCountLabel;
}

@end
