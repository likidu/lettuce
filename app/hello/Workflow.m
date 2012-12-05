//
//  Workflow.m
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import "Workflow.h"

@interface Workflow ()

@property(nonatomic,retain) NSMutableDictionary* keyActionMap;
@property(nonatomic,retain) NSMutableDictionary* sourceTargetMap;
@property(nonatomic,retain) NSString* currentStateKey;

@end

@implementation Workflow

@synthesize keyActionMap;
@synthesize sourceTargetMap;
@synthesize context;
@synthesize currentStateKey;
@synthesize completed;

- (id)init {
    self = [super init];
    if (self) {
        self.keyActionMap = [NSMutableDictionary dictionary];
        self.sourceTargetMap = [NSMutableDictionary dictionary];
        self.context = [NSMutableDictionary dictionary];
        self.completed = NO;
        self.workflowCompleteHandler = nil;
    }
    return self;
}

- (void)dealloc {
    [self.keyActionMap enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL * stop) {
        Block_release(object);
        *stop = NO;
    }];
    self.keyActionMap = nil;
    self.sourceTargetMap = nil;
    self.context = nil;
    self.workflowCompleteHandler = nil;
    [super dealloc];
}

- (void)setAction:(Action)action withMesageMap:(NSDictionary *)map forKey:(NSString *)key {
    [self.keyActionMap setObject:Block_copy(action) forKey:key];
    [self.sourceTargetMap setObject:map forKey:key];
}

- (void)removeActionByKey:(NSString *)key {
    Action action = [self.keyActionMap objectForKey:key];
    if (action)
        Block_release(action);
    [self.keyActionMap removeObjectForKey:key];
    [self.sourceTargetMap removeObjectForKey:key];
}

- (void)execute {
    Action action = [keyActionMap objectForKey:START_STATE_KEY];
    if (action) {
        self.currentStateKey = START_STATE_KEY;
        action(self);
    }
}

#pragma mark - delegate

-(void)sendMessage:(NSString *)message {
    NSDictionary* messageMap = [sourceTargetMap objectForKey:currentStateKey];
    if (messageMap) {
        NSString* targetStateKey = [messageMap objectForKey:message];
        if (targetStateKey) {
            Action action = [keyActionMap objectForKey:targetStateKey];
            if (action) {
                self.currentStateKey = targetStateKey;
                action(self);
                return;
            }
        }
    }
    self.completed = YES;
    if (self.workflowCompleteHandler)
        self.workflowCompleteHandler();
}

- (NSDictionary *)retrieveContext {
    return self.context;
}

@end
