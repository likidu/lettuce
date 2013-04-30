//
//  ConfigurationManager.h
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REMINDER_SWITCH_KEY @"ActiveAccountingReminderOn"
#define REMINDER_TYPE_KEY @"ActiveAccountingReminderType"
#define REMINDER_TIME_KEY @"ActiveAccountingReminderTime"
#define BACKUP_TIME_KEY @"LastBackupAndRecoverTime"
#define TRANSACTIONVIEW_STARTUP_KEY @"TransactionViewAtStartup"
#define PASSWORD_KEY @"Passcode"
#define ACTIVE_PASSWORD_KEY @"ActivePassword"
#define WEIBO_ACCOUNT_KEY @"WeiboAccount"
#define WEIBO_USER_ID @"WeiboAccountUserId"
#define WEIBO_ACCESS_TOKEN @"WeiboAccountAccessToken"
#define WEIBO_EXPIRATION_DATE @"WeiboAccountExpirationDate"

@interface ConfigurationManager : NSObject
+ (NSDictionary *) getAllConfigurations;
@end
