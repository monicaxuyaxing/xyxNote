//
//  NoteModel.h
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *noteID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *bgImageName;



- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate
        bgImageName:(NSString *)bgImageName;

- (BOOL)Persistence;


@end
