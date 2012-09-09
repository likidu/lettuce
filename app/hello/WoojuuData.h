//
//  WoojuuData.h
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoojuuData : NSObject
@property (retain, nonatomic) NSDictionary *configurationData;
@property (retain, nonatomic) NSObject *databaseData;
- (id)initWithName:(NSDictionary *)configuration :(NSData *)database;
@end
