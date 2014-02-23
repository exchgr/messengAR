//
//  MSGRMessageStore.m
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRMessageStore.h"
#import "MSGRMessage.h"

@implementation MSGRMessageStore

+ (MSGRMessageStore *)sharedStore
{
    static MSGRMessageStore *sharedStore = nil;
    if (!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        NSString *path = [self archivePath];
        allMessages = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allMessages)
        {
            allMessages = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allMessages
{
    return allMessages;
}

- (void)addMessage:(MSGRMessage *)message
{
    [allMessages addObject:message];
}

- (void)removeMessage:(MSGRMessage *)message
{
    [allMessages removeObjectIdenticalTo:message];
}

- (NSString *)archivePath
{
    NSString *localPath = @"Documents/messages.archive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    return fullPath;
}

- (BOOL)saveChanges
{
    NSString *path = [self archivePath];
    return [NSKeyedArchiver archiveRootObject:allMessages toFile:path];
}

- (void)clear
{
    while ([allMessages count] > 0)
    {
        [allMessages removeObjectAtIndex:0];
    }
}

@end
