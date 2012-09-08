//
//  NSString+NSStringAdditions.m
//  woojuu
//
//  Created by Liangying Wei on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
- (BOOL) contains:(NSString *)string options:(NSStringCompareOptions)options{
    NSRange range = [self rangeOfString:string options:options];
    return range.location != NSNotFound;
}

- (BOOL) contains:(NSString *)string{
    return [self contains:string options:NSCaseInsensitiveSearch];
}
@end
