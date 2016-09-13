//
//  NoteManager.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "NoteManager.h"
#import "NoteModel.h"
#import "Constants.h"

@implementation NoteManager

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (NSString *)createDataPathIfNeeded
{
    NSString *documentsDirectory = [self documentDirectoryPath];
    self.docPath = documentsDirectory;
    
    //判断路径是否存在于文件夹
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        return self.docPath;
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
        
    }
    return self.docPath;
}
/**
 *  数据持久化保持在document目录下
 */

- (NSString *)documentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:kAppEngName];
    //NSLog(@"%@",documentsDirectory);
    
    return documentsDirectory;
}

- (NSMutableArray *)readAllNotes
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error;
    NSString *documentsDirectory = [self createDataPathIfNeeded];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Create Note for each file
    for (NSString *file in files) {
        NoteModel *note = [self readNoteWithID:file];
        if (note) {
            [array addObject:note];
        }
    }
    return array;
}



- (NoteModel *)readNoteWithID:(NSString *)noteID;
{
    NSString *dataPath = [_docPath stringByAppendingPathComponent:noteID];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) {
        return nil;
    }
    NoteModel *note = [NSKeyedUnarchiver unarchiveObjectWithData:codedData];
    
    return note;
}

- (BOOL)storeNote:(NoteModel *)note
{
    [self createDataPathIfNeeded];
    NSString *dataPath = [_docPath stringByAppendingPathComponent:note.noteID];
    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:note];
    return [savedData writeToFile:dataPath atomically:YES];
}

- (void)deleteNote:(NoteModel *)note
{
    NSString *filePath = [_docPath stringByAppendingPathComponent:note.noteID];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:note.content error:nil];
  [[NSFileManager defaultManager] removeItemAtPath:note.bgImageName error:nil];
    //[[NSFileManager defaultManager] removeItemAtPath:note. error:nil];


}



@end
