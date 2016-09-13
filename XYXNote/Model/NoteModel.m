//
//  NoteModel.m
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.
//

#import "NoteModel.h"
#import "NoteManager.h"

#define kNoteIDKey      @"NoteID"
#define kTitleKey       @"Title"
#define kContentKey     @"Content"
#define kCreatedDate    @"CreatedDate"
#define kUpdatedDate    @"UpdatedDate"
#define kImageName    @"ImageName"

@implementation NoteModel

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate
        bgImageName:(NSString *)bgImageName;

{
    self = [super init];
    if (self) {
        _noteID = [[NSNumber numberWithDouble:[createdDate timeIntervalSince1970]] stringValue];
        _title = title;
        _content = content;
        _createdDate = createdDate;
        _updatedDate = updatedDate;
        _bgImageName = bgImageName;
        if (_title == nil || _title.length == 0) {
            
            _title = @"";
        }
        if (_content == nil || _content.length == 0) {
            _content = @"";
        }
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_noteID forKey:kNoteIDKey];
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_content forKey:kContentKey];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
    [encoder encodeObject:_bgImageName forKey:kImageName];


}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    NSString *content = [decoder decodeObjectForKey:kContentKey];
    NSDate *createDate = [decoder decodeObjectForKey:kCreatedDate];
    NSDate *updateDate = [decoder decodeObjectForKey:kUpdatedDate];
    NSString *bgImageName = [decoder decodeObjectForKey:kImageName];


    return [self initWithTitle:title
                       content:content
                   createdDate:createDate
                    updateDate:updateDate
                   bgImageName:bgImageName];
}

- (BOOL)Persistence
{
    return [[NoteManager sharedManager] storeNote:self];
}



@end
