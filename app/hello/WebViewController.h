//
//  WebViewController.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-6-4.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

- (id)initWithURL:(NSString *)url;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString* startUrl;

@end
