//
//  AlertTableViewController.m
//  玩记
//
//  Created by monica on 16/7/25.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "AlertTableViewController.h"
#import "AlertCell.h"
#import "DatePickerController.h"
#import "Notification.h"
#import "NoteModel.h"
#define screenWidth [UIScreen mainScreen].bounds.size.width



@interface AlertTableViewController ()

@property (nonatomic,strong) NSMutableDictionary *selectedDic;


@end

@implementation AlertTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
  
   
    
}

-(void)setupUI{
    

    
    self.navigationItem.title = @"提醒设置";

    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                           action:@selector(edit:)];
  
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

-(NSMutableDictionary*)selectedDic{
    if (_selectedDic==nil) {
        _selectedDic = [[NSMutableDictionary alloc]init];
    }
    return _selectedDic;
}

- (void)edit:(UIBarButtonItem *)sender {
    [self setEditing:!self.editing animated:YES];
    if (self.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
       
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        if (self.selectedDic.count>0) {
            NSArray *array = [self.selectedDic allKeys];
            [self.dataArray removeObjectsInArray:array];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.selectedDic allValues]] withRowAnimation:UITableViewRowAnimationFade];
            
            for (NSString *s in [self.selectedDic allKeys]) {
                NSLog(@"sssss  %@",s);
                
                [[Notification sharedNotification] cancelLocalNotificationWithValue:s];
                
           }
            
            NSLog(@"keysssss   %@",self.selectedDic);
            [self.selectedDic removeAllObjects];
        }
    }
}



#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果你确定所有cell的高度都是固定的，就没必要实现该方法，也没必要手动计算高度
    NSDictionary *dataDic = @{@"content":self.dataArray[indexPath.row]};
    return [AlertCell heightForCellWithDic:dataDic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"alertCell";
    
    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        //如果缓存池没有cell，初始化
        cell =[[AlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    
    NSDictionary *dataDic = @{@"content":self.dataArray[indexPath.row]};
//   
//    NSLog(@"alertseconds:%ld",(long)_alertseconds);
//    NSLog(@"alertnote:%@",_alertnote.title);
//    
      //更新数据
    [cell updateCellWithDic:dataDic];
    cell.cellText.numberOfLines = 0;
     NSLog(@"delete:%@",self.dataArray[indexPath.row]);


   

    
    return cell;
}
//编辑样式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//添加一项

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (tableView.editing) {
        [self.selectedDic setObject:indexPath forKey:self.dataArray[indexPath.row]];
    }
   
        
}

//取消一项

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (tableView.editing) {
        [self.selectedDic removeObjectForKey:self.dataArray[indexPath.row]];
    }
}
//删除员工
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row <= [self.dataArray count]) {
      
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    
   
    
}

@end
