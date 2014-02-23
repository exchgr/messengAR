//
//  MSGRMessageStore.h
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSGRMessage;

@interface MSGRMessageStore : NSObject

{
    NSMutableArray *allMessages;
}

+ (MSGRMessageStore *)sharedStore;
- (NSArray *)allMessages;
- (void)addMessage:(MSGRMessage *)message;
- (void)removeMessage:(MSGRMessage *)message;
- (NSString *)archivePath;
- (BOOL)saveChanges;
- (void)clear;

@end
