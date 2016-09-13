//
//  ListViewCell.h
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface ListViewCell : UITableViewCell

+ (CGFloat)heightWithNote:(NoteModel *)note;
- (void)updateWithNote:(NoteModel *)note;


@end
