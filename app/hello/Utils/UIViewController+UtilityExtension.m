//
//  UIViewController+UtilityExtension.m
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+UtilityExtension.h"
#import <objc/runtime.h>

#define PROPNAME_PARENTMODALVIEWCONTROLLER @"parentModalViewController"
#define PROPNAME_PRESENTINGVIEWCONTROLLER @"presentingViewController"

@interface ViewControllerObserver : NSObject

+ (ViewControllerObserver*)instance;
+ (void)addObserverOnViewController:(UIViewController *)viewController;
+ (void)removeObserverOnViewController:(UIViewController*)viewController;

@end

static ViewControllerObserver* observerInstance = nil;

@implementation ViewControllerObserver

+ (ViewControllerObserver *)instance {
    if (observerInstance == nil)
        observerInstance = [[ViewControllerObserver alloc]init];
    return observerInstance;
}

+ (void)addObserverOnViewController:(UIViewController *)viewController {
    [viewController addObserver:[ViewControllerObserver instance] forKeyPath:PROPNAME_PARENTMODALVIEWCONTROLLER options:0 context:nil];
    [viewController addObserver:[ViewControllerObserver instance] forKeyPath:PROPNAME_PRESENTINGVIEWCONTROLLER options:0 context:nil];
}

+ (void)removeObserverOnViewController:(UIViewController*)viewController {
    [viewController removeObserver:[ViewControllerObserver instance] forKeyPath:PROPNAME_PARENTMODALVIEWCONTROLLER];
    [viewController removeObserver:[ViewControllerObserver instance] forKeyPath:PROPNAME_PRESENTINGVIEWCONTROLLER];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:PROPNAME_PARENTMODALVIEWCONTROLLER] && ![keyPath isEqualToString:PROPNAME_PRESENTINGVIEWCONTROLLER])
        return;
    
    if ([[object class]isSubclassOfClass:[UIViewController class]]) {
        UIViewController* viewController = (UIViewController*)object;
        id<UIViewControllerDelegate> delegate = viewController.delegate;
        if (!delegate) {
            ViewControllerDismissedBlock block = viewController.dismissHandler;
            if (!viewController.presentingViewController && block) {
                block(viewController);
            }
            return;
        }
        
        if (viewController.parentViewController && [delegate respondsToSelector:@selector(didPresentViewController::)])
            [delegate didPresentViewController:viewController];
        if (!viewController.parentViewController && [delegate respondsToSelector:@selector(didDismissViewController:)])
            [delegate didDismissViewController:viewController];
        
    }
}

@end

static NSString * UIViewControllerDelegateKey = @"UIViewControllerDelegate";
static NSString * UIViewControllerDismissHanlderKey = @"UIViewControllerDismissHandler";

@implementation UIViewController (UtilityExtension)

+ (UIViewController *)instanceFromNib {
    NSString* className = [NSString stringWithCString:class_getName(self) encoding:NSASCIIStringEncoding];
    UIViewController* viewController = [[[self alloc]initWithNibName:className bundle:[NSBundle mainBundle]]autorelease];
    
    [ViewControllerObserver addObserverOnViewController:viewController];
    
    return viewController;
}

+ (UIViewController*)instanceFromNib:(NSString*)nibname {
    if (nibname == nil || nibname.length == 0)
        return [UIViewController instanceFromNib];
    
    UIViewController* vc = [[[self alloc]initWithNibName:nibname bundle:[NSBundle mainBundle]]autorelease];
    
    [ViewControllerObserver addObserverOnViewController:vc];
    
    return vc;
}

- (id)delegate {
    return objc_getAssociatedObject(self, UIViewControllerDelegateKey);
}

- (void)setDelegate:(id)delegate {
    objc_setAssociatedObject(self, UIViewControllerDelegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (ViewControllerDismissedBlock)dismissHandler {
    return objc_getAssociatedObject(self, UIViewControllerDismissHanlderKey);
}

- (void)setDismissHandler:(ViewControllerDismissedBlock)dismissHandler {
    ViewControllerDismissedBlock original = objc_getAssociatedObject(self, UIViewControllerDismissHanlderKey);
    if (original)
        Block_release(original);

    objc_setAssociatedObject(self, UIViewControllerDismissHanlderKey, dismissHandler, OBJC_ASSOCIATION_COPY);
}

@end

