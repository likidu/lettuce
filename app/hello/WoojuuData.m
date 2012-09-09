//
//  WoojuuData.m
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoojuuData.h"

@implementation WoojuuData
@synthesize configurationData;
@synthesize databaseData;

- (id)initWithName:(NSDictionary *)configuration :(NSData *)database{
    self = [super init];
    if (self){
        self.configurationData = configuration;
        self.databaseData = database;
    }
    
    return self;
}

- (void)dealloc{
    self.configurationData = nil;
    self.databaseData = nil;
    [super dealloc];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"::%@", configurationData];
}
@end
