//
//  NoteManager.h
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@class NoteModel;
@interface NoteManager : NSObject

@property (nonatomic, strong) NSString *docPath;

- (NSMutableArray *)readAllNotes;


- (NoteModel *)readNoteWithID:(NSString *)noteID;
- (BOOL)storeNote:(NoteModel *)note;
- (void)deleteNote:(NoteModel *)note;

+ (instancetype)sharedManager;


@end
