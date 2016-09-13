//
//  NotepadViewController.h
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "iflyMSC/IFlyMSC.h"



@interface NotepadViewController : UIViewController<IFlyRecognizerViewDelegate>

-(instancetype)initWithContent:(NSAttributedString *)string  AndNote:(NoteModel *)note;
@property (nonatomic,strong)IFlyRecognizerView *iflyRecognizerView;


@end
