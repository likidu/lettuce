//
//  NSString+NSStringAdditions.h
//  woojuu
//
//  Created by Liangying Wei on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)
- (BOOL) contains:(NSString *)string;
- (BOOL) contains:(NSString *)string 
          options:(NSStringCompareOptions) options;
@end
