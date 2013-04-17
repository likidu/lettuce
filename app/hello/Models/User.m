//
//  User.m
//  woojuu
//
//  Created by Liki Du on 4/16/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "User.h"
#import "ConfigurationManager.h"

@implementation User

@synthesize isAuthorizeExpired;
@synthesize isAuthorized;
@synthesize accountInfo = _accountInfo;

- (id)init {
    self = [super self];
    if (!self) {
        return nil;
    }
    
    NSDictionary *accountInfoUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:WEIBO_ACCOUNT_KEY];
    
    // Could be nil for the first time creation
    _accountInfo = accountInfoUserDefault;
    
    return self;
}

- (void)update:(NSDictionary *)accountInfo {
    [[NSUserDefaults standardUserDefaults] setObject:accountInfo forKey:WEIBO_ACCOUNT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isAuthorizeExpired {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Time format for the string value
    // 2013-04-17 19:07:28 +0000
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate *expirationDate = [dateFormatter dateFromString:self.accountInfo[WEIBO_ACCESS_TOKEN]];
    NSDate *now = [NSDate date];
    return ([now compare:expirationDate] == NSOrderedDescending);
}

@end
