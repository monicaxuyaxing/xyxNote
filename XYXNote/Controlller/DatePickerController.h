//
//  DatePickerController.h
//  玩记
//
//  Created by monica on 16/7/24.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDatePicker.h"
#import "NoteModel.h"

typedef void (^ReturnTextBlock)(NSMutableArray *showArray);

@interface DatePickerController : UIViewController<UITextViewDelegate, KMDatePickerDelegate>
@property(nonatomic,strong) NSString *startTime;

@property (nonatomic, strong) UITextView *alertText;
@property (nonatomic,weak) NoteModel *note;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger seconds;

-(instancetype)initWithNote:(NoteModel *)note;



@end
