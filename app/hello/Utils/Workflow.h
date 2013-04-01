//
//  Workflow.h
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import <Foundation/Foundation.h>

@protocol WorkflowDelegate <NSObject>

@required
- (NSMutableDictionary*)retrieveContext;
- (void)sendMessage:(NSString*)message;

@end

typedef void (^Action)(id<WorkflowDelegate> delegate);
typedef void (^WorkflowDidComplete)();
#define START_STATE_KEY @"start"

@interface Workflow : NSObject<WorkflowDelegate>

@property(nonatomic,retain) NSMutableDictionary* context;
@property(nonatomic,assign) BOOL completed;
@property(nonatomic,copy) WorkflowDidComplete workflowCompleteHandler;

- (void)setAction:(Action)action withMesageMap:(NSDictionary*)map forKey:(NSString*)key;
- (void)removeActionByKey:(NSString*)key;

- (void)execute;

@end
