//
//  MSGRUsernameStore.h
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGRUsernameStore : NSObject

{
    NSMutableArray *usernames;
}

+ (MSGRUsernameStore *)sharedStore;
- (NSArray *)usernames;
- (void)addUsername:(NSString *)username;
- (void)removeUsername:(NSString *)username;
- (NSString *)archivePath;
- (BOOL)saveChanges;

@end
