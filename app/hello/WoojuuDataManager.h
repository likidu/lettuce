//
//  WoojuuDataManager.h
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WoojuuData.h"

@interface WoojuuDataManager : NSObject
+ (WoojuuData *)getWoojuuData;
+ (void)setDataToWoojuu: (WoojuuData *)data;
@end
