//
//  alertCell.h
//  玩记
//
//  Created by monica on 16/7/27.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertCell : UITableViewCell

@property (strong, nonatomic)UILabel *cellText;

- (void) updateCellWithDic:(NSDictionary *)dic;

+ (CGFloat)heightForCellWithDic:(NSDictionary *)dic;
@end
