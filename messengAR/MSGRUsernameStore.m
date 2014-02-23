//
//  MSGRUsernameStore.m
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRUsernameStore.h"

@implementation MSGRUsernameStore

+ (MSGRUsernameStore *)sharedStore
{
    static MSGRUsernameStore *sharedStore = nil;
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
        usernames = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!usernames)
        {
            usernames = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)usernames
{
    return usernames;
}

- (void)addUsername:(NSString *)username
{
    [usernames addObject:username];
}

- (void)removeUsername:(NSString *)username
{
    [usernames removeObjectIdenticalTo:usernames];
}

- (NSString *)archivePath
{
    NSString *localPath = @"Documents/usernames.archive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    return fullPath;
}

- (BOOL)saveChanges
{
    NSString *path = [self archivePath];
    return [NSKeyedArchiver archiveRootObject:usernames toFile:path];
}


@end
