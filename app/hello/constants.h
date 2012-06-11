//
//  constants.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-6-4.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#ifndef woojuu_constants_h
#define woojuu_constants_h

// API service settings
#ifdef DEBUG
    // In the future, we can have different test url for debug purpose.
    #define apiBaseURL @"http://api.woojuu.cc/"
#else
    #define apiBaseURL @"http://api.woojuu.cc/"
#endif

#endif
