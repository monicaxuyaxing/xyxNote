//
//  DatePickerController.m
//  玩记
//
//  Created by monica on 16/7/24.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "DatePickerController.h"
#import "DateHelper.h"
#import "NSDate+CalculateDay.h"
#import "NoteModel.h"
#import "UIColor+CustomColor.h"
#import "SVProgressHUD.h"
#import "NoteModel.h"
#import "Constants.h"
#import "AlertTableViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "Notification.h"


@interface DatePickerController ()


@end


@implementation DatePickerController{
    NSString *dateStr;
}
-(instancetype)initWithNote:(NoteModel *)note{
    
    self = [super init];
    if (self) {
        
        
        _note = note;
        
    }
    return self;
}




-(void)viewDidLoad{
    
    [self setupUI];
}

-(NSMutableArray*)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [[NSMutableArray alloc]init];
        
    }
    return _dataArray;
}

- (void)setupUI
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = saveItem;
    self.navigationItem.title = @"提醒设置";
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    self.alertText = [[UITextView alloc] initWithFrame:CGRectMake(30, 100, rect.size.width-60, 80)];
    
    _alertText.textColor = [UIColor blackColor];
    _alertText.font = [UIFont systemFontOfSize:15];
    _alertText.autocorrectionType = UITextAutocorrectionTypeNo;
    _alertText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_alertText setScrollEnabled:YES];
    [_alertText setBackgroundColor: [UIColor clearColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.alertText.layer.borderWidth = 1.0;
    self.alertText.layer.borderColor = [UIColor grayColor].CGColor;
    self.alertText.layer.cornerRadius = 5.0;
    
    
    [self.view addSubview:_alertText];
    
    rect = CGRectMake(0.0, 0.0, rect.size.width, 240.0);
    // 年月日时分
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:rect
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDayHourMinute];
    _alertText.inputView = datePicker;
    _alertText.delegate = self;
    datePicker.backgroundColor = [UIColor datePickerColor];
    
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextView *)textField {
    _alertText = textField;
}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
   dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day,
                         datePickerDate.hour,
                         datePickerDate.minute
                         //datePickerDate.weekdayName
                         ];
    
    NSLog(@"4444 %@",dateStr);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.startTime = [formatter stringFromDate:[NSDate date]];
    
    
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags=NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
    NSDateComponents *d = [cal components:unitFlags fromDate:[NSDate date] toDate:[formatter dateFromString:dateStr] options:0];
    NSLog(@"%ld天%ld小时%ld分钟",(long)[d day],(long)[d hour],(long)[d minute]);
    _seconds = [d day]*24*60*60 + [d hour]*60*60 + [d minute]*60;
    
    NSLog(@"seconds  %ld",(long)_seconds);
    if (_seconds <0 ) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择正确的时间(必须晚于现在时)"];
        _alertText.text = nil;
        
    }
    
    _alertText.text = [NSString stringWithFormat:@"事件:%@  将于%@提醒",_note.title,dateStr];
    
    //_txtFCurrent.text = _note.title;
}

-(void)save{
    
    if (_alertText.text == nil || _alertText.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"未设置内容"];
        return;
    }
    
    NSString *str = _alertText.text;
    
    NSLog(@"dddd%@",str);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabarController = (UITabBarController *)app.window.rootViewController;
    UINavigationController *secondNavigationController = [tabarController viewControllers][1];
    AlertTableViewController *second = (AlertTableViewController *)secondNavigationController.viewControllers[0];
    
     [[Notification sharedNotification] registerLocalNotification:_seconds+59 WithalertBody:str AnduserDict:str];
    

    
    [second.dataArray addObject:str];    
    
    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
   

    
    NSLog(@"4444%lu",(unsigned long)self.dataArray.count);
    
    self.tabBarController.selectedIndex = 1;
}


- (NSString*)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  //注意，括号里面的第一个元素是NSDocumentDirectory，而不是NSDocumentationDirectory
    
    //2.获取文件路径数组的第一个元素，因为我们只需要这一个
    NSString *documentPath = [paths objectAtIndex:0];
    
    //3.获取第2步得到的元素的字符串，并创建一个名为data.plist的.plist文件用于保存数据
    NSString *fileName = [documentPath stringByAppendingPathComponent:@"data.plist"];
    return fileName;
    
}









@end
