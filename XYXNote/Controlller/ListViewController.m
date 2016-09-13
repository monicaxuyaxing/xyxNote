//
//  ListViewController.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "ListViewController.h"
#import "NoteModel.h"
#import "NoteManager.h"
#import "Constants.h"
#import "NotepadViewController.h"
#import "ListViewCell.h"
#import "xyxGuideViewManager.h"
#import "DatePickerController.h"
#import "UIImage+SLImage.h"


#define WIDTH ([UIScreen  mainScreen].bounds.size.width)


@interface ListViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation ListViewController{
    UITableViewRowAction *deleteRowAction;
    UITableViewRowAction *alertRowAction;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *images = [NSMutableArray new];
    UIImage *image1 = [UIImage imageNamed:@"lanchflow111"];
    image1 = [image1 scaleToSize:CGSizeMake(WIDTH, self.view.bounds.size.height*WIDTH/self.view.bounds.size.width)];
    UIImage *image2 = [UIImage imageNamed:@"lanchflow222"];
    image2 = [image2 scaleToSize:CGSizeMake(WIDTH, self.view.bounds.size.height*WIDTH/self.view.bounds.size.width)];
    UIImage *image3 = [UIImage imageNamed:@"lanchflow333"];
    image3 = [image3 scaleToSize:CGSizeMake(WIDTH, self.view.bounds.size.height*WIDTH/self.view.bounds.size.width)];
    [images addObject:image1];
    [images addObject:image2];
    [images addObject:image3];

    
    [[xyxGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                   andButtonTitle:@"立即体验"
                                              andButtonTitleColor:[UIColor blackColor]
                                                 andButtonBGColor:[UIColor clearColor]
                                             andButtonBorderColor:[UIColor blackColor]];

    [self setupNavigationBar];
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

   [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(reloadData)
                                         name:kNotificationCreateFile
                                        object:nil];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NoteManager sharedManager] readAllNotes];
    }
    return _dataSource;
}

- (void)setupNavigationBar
{
    
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addbutton.frame = CGRectMake(0, 0, 60,60);
    
    
    [addbutton setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    
    [addbutton addTarget:self action:@selector(createTask) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addbutton];
    
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = kAppName;
    
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"返回"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                        action:nil];


}

- (void)reloadData
{
    _dataSource = [[NoteManager sharedManager] readAllNotes];
    
    [self.tableView reloadData];
}


- (void)createTask
{
    NotepadViewController *controller = [[NotepadViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteModel *note = [self.dataSource objectAtIndex:indexPath.row];
    return [ListViewCell heightWithNote:note];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
           }
    NoteModel *note = [self.dataSource objectAtIndex:indexPath.row];
    [cell updateWithNote:note];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NoteModel *note = [self.dataSource objectAtIndex:indexPath.row];
    
    NSLog(@"title%@",note.title);
    NSLog(@"Content------%@",note.content);
    //NSLog(@"bgimagepath  %@",note.bgImagePath);


    NSData *outputData = [NSData dataWithContentsOfFile:note.content];
//
//    NSLog(@"data %@",picData);
    
    NSError *erro  = nil;

    
    NSAttributedString *temp = [[NSAttributedString alloc] initWithData:outputData options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:&erro];
  
    
    NSLog(@"temp------%@  %@",temp,erro);
   // NSLog(@"picPath ---- %@",picPath);
    
        
    //读取
    
    NotepadViewController *controller = [[NotepadViewController alloc] initWithContent:temp AndNote:note];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - EditMode

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
            // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NoteModel *note = [self.dataSource objectAtIndex:indexPath.row];
            [[NoteManager sharedManager] deleteNote:note];
            
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
        
        // 添加一个提醒按钮
        alertRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"提醒" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            self.hidesBottomBarWhenPushed=YES;
            //self.tabBarController.selectedIndex = 1;
            NoteModel *note = [self.dataSource objectAtIndex:indexPath.row];


            DatePickerController *datepicker = [[DatePickerController alloc]initWithNote:note];
          
            [self.navigationController pushViewController:datepicker animated:NO];
            self.hidesBottomBarWhenPushed=NO;
            alertRowAction.backgroundColor = [UIColor blueColor];
        
        alertRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        }];
    return @[deleteRowAction,alertRowAction];

        }

@end
