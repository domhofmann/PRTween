
#import "PRTween.h"

#define kPRTweenFramerate 1.0/60

@implementation PRTweenPeriod
@synthesize startValue;
@synthesize endValue;
@synthesize tweenedValue;
@synthesize duration;
@synthesize delay;
@synthesize startOffset;

+ (id)periodWithStartValue:(CGFloat)aStartValue endValue:(CGFloat)anEndValue duration:(CGFloat)duration {
    PRTweenPeriod *period = [PRTweenPeriod new];
    
    period.startValue = period.tweenedValue = aStartValue;
    period.endValue = anEndValue;
    period.duration = duration;
    period.startOffset = [[PRTween sharedInstance] timeOffset];
    
    return [period autorelease];
}

@end

@implementation PRTweenLerpPeriod
@synthesize startLerp;
@synthesize endLerp;
@synthesize tweenedLerp;

+ (id)periodWithStartValue:(NSValue*)aStartValue endValue:(NSValue*)anEndValue duration:(CGFloat)duration {
    PRTweenLerpPeriod *period = [[self class] new];
    period.startLerp = aStartValue;
    period.tweenedLerp = aStartValue;
    period.endLerp = anEndValue;
    period.duration = duration;
    period.startOffset = [[PRTween sharedInstance] timeOffset];
    
    return [period autorelease];
}

- (void)dealloc {
    [startLerp release];
    [endLerp release];
    [tweenedLerp release];
    [super dealloc];
}

@end

@implementation PRTweenCGPointLerpPeriod

+ (id)periodWithStartCGPoint:(CGPoint)aStartPoint endCGPoint:(CGPoint)anEndPoint duration:(CGFloat)duration {
    return [PRTweenCGPointLerpPeriod periodWithStartValue:[NSValue valueWithCGPoint:aStartPoint] endValue:[NSValue valueWithCGPoint:anEndPoint] duration:duration];
}

- (CGPoint)startCGPoint { return [self.startLerp CGPointValue]; }
- (CGPoint)tweenedCGPoint { return [self.tweenedLerp CGPointValue]; }
- (CGPoint)endCGPoint { return [self.endLerp CGPointValue]; }

- (NSValue*)tweenedValueForProgress:(CGFloat)progress {
    
    CGPoint startPoint = self.startCGPoint;
    CGPoint endPoint = self.endCGPoint;
    CGPoint distance = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    CGPoint tweenedPoint = CGPointMake(startPoint.x + distance.x * progress, startPoint.y + distance.y * progress);
    
    return [NSValue valueWithCGPoint:tweenedPoint];
    
}

- (void)setProgress:(CGFloat)progress {
    self.tweenedLerp = [self tweenedValueForProgress:progress];
}

@end

@implementation PRTweenCGRectLerpPeriod

+ (id)periodWithStartCGRect:(CGRect)aStartRect endCGRect:(CGRect)anEndRect duration:(CGFloat)duration {
    return [PRTweenCGRectLerpPeriod periodWithStartValue:[NSValue valueWithCGRect:aStartRect] endValue:[NSValue valueWithCGRect:anEndRect] duration:duration];
}

- (CGRect)startCGRect { return [self.startLerp CGRectValue]; }
- (CGRect)tweenedCGRect { return [self.tweenedLerp CGRectValue]; }
- (CGRect)endCGRect { return [self.endLerp CGRectValue]; }

- (NSValue *)tweenedValueForProgress:(CGFloat)progress {
    
    CGRect startRect = self.startCGRect;
    CGRect endRect = self.endCGRect;
    CGRect distance = CGRectMake(endRect.origin.x - startRect.origin.x, endRect.origin.y - startRect.origin.y, endRect.size.width - startRect.size.width, endRect.size.height - startRect.size.height);
    CGRect tweenedRect = CGRectMake(startRect.origin.x + distance.origin.x * progress, startRect.origin.y + distance.origin.y * progress, startRect.size.width + endRect.size.width * progress, startRect.size.height + endRect.size.height * progress);
    
    return [NSValue valueWithCGRect:tweenedRect];
    
}

- (void)setProgress:(CGFloat)progress {
    self.tweenedLerp = [self tweenedValueForProgress:progress];
}

@end

@implementation PRTweenOperation
@synthesize period;
@synthesize target;
@synthesize updateSelector;
@synthesize completeSelector;
@synthesize timingFunction;
@synthesize boundRef;
@synthesize boundObject;
@synthesize boundGetter;
@synthesize boundSetter;

#if NS_BLOCKS_AVAILABLE
@synthesize updateBlock;
@synthesize completeBlock;
#endif

- (void)dealloc {
#if NS_BLOCKS_AVAILABLE
    [updateBlock release];
    [completeBlock release];
#endif
    [period release];
    [target release];
    [boundObject release];
    [super dealloc];
}

@end

@implementation PRTweenCGPointLerp

+ (void)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    [PRTween lerp:object property:property period:[PRTweenCGPointLerpPeriod periodWithStartCGPoint:from endCGPoint:to duration:1] timingFunction:timingFunction target:target completeSelector:selector];
}

+ (void)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration {
    [PRTweenCGPointLerp lerp:object property:property from:from to:to duration:duration timingFunction:[PRTween sharedInstance].defaultTimingFunction target:nil completeSelector:NULL];
}

#if NS_BLOCKS_AVAILABLE
+ (void)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {
    [PRTween lerp:object property:property period:[PRTweenCGPointLerpPeriod periodWithStartCGPoint:from endCGPoint:to duration:1] timingFunction:timingFunction updateBlock:updateBlock completeBlock:completeBlock];
}
#endif

@end

@implementation PRTweenCGRectLerp

+ (void)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    [PRTween lerp:object property:property period:[PRTweenCGRectLerpPeriod periodWithStartCGRect:from endCGRect:to duration:1] timingFunction:timingFunction target:target completeSelector:selector];
}

+ (void)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration {
    [PRTweenCGRectLerp lerp:object property:property from:from to:to duration:duration timingFunction:[PRTween sharedInstance].defaultTimingFunction target:nil completeSelector:NULL];
}

#if NS_BLOCKS_AVAILABLE
+ (void)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock { 
    [PRTweenCGRectLerp lerp:object property:property from:from to:to duration:duration timingFunction:[PRTween sharedInstance].defaultTimingFunction updateBlock:updateBlock completeBlock:completeBlock];
}
#endif

@end

@interface PRTween ()
- (void)update;
@end

static PRTween *instance;

@implementation PRTween
@synthesize timeOffset;
@synthesize defaultTimingFunction;

+ (PRTween *)sharedInstance {
    if (instance == nil) {
        instance = [[PRTween alloc] init];
    }
    return instance;
}

+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector {
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.completeSelector = selector;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property capitalizedString]]);
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}

+ (void)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector {
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.completeSelector = selector;
    operation.boundRef = ref;
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}

+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration {
    [PRTween tween:object property:property from:from to:to duration:duration timingFunction:[PRTween sharedInstance].defaultTimingFunction target:nil completeSelector:NULL];
}

+ (void)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration {
    [PRTween tween:ref from:from to:to duration:duration timingFunction:[PRTween sharedInstance].defaultTimingFunction target:nil completeSelector:NULL];
}

+ (void)lerp:(id)object property:(NSString *)property period:(PRTweenLerpPeriod <PRTweenLerpPeriod> *)period  timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    
    //PRTweenPeriod *period = [PRTweenLerpPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.completeSelector = selector;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property capitalizedString]]);
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedLerp" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}

#if NS_BLOCKS_AVAILABLE
+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property capitalizedString]]);
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}

+ (void)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundRef = ref;
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}

+ (void)lerp:(id)object property:(NSString *)property period:(PRTweenLerpPeriod <PRTweenLerpPeriod> *)period  timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock {
    
    //PRTweenPeriod *period = [PRTweenLerpPeriod periodWithStartValue:from endValue:to duration:duration];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property capitalizedString]]);
    [operation addObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedLerp" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    
}
#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    PRTweenOperation *operation = (PRTweenOperation*)object;
    
    if ([operation.period isKindOfClass:[PRTweenLerpPeriod class]]) {
        PRTweenLerpPeriod *lerpPeriod = (PRTweenLerpPeriod*)operation.period;
        
        NSUInteger bufferSize = 0;
        NSGetSizeAndAlignment([lerpPeriod.tweenedLerp objCType], &bufferSize, NULL);
        void *tweenedValue = malloc(bufferSize);
        [lerpPeriod.tweenedLerp getValue:tweenedValue];
        
        if (operation.boundObject && [operation.boundObject respondsToSelector:operation.boundGetter] && [operation.boundObject respondsToSelector:operation.boundSetter]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[operation.boundObject class] instanceMethodSignatureForSelector:operation.boundSetter]];
            [invocation setTarget:operation.boundObject];
            [invocation setSelector:operation.boundSetter];
            [invocation setArgument:tweenedValue atIndex:2];
            [invocation invoke];
        }
        
        free(tweenedValue);
        
    } else {
        
        CGFloat tweenedValue = operation.period.tweenedValue;
        
        if (operation.boundObject && [operation.boundObject respondsToSelector:operation.boundGetter] && [operation.boundObject respondsToSelector:operation.boundSetter]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[operation.boundObject class] instanceMethodSignatureForSelector:operation.boundSetter]];
            [invocation setTarget:operation.boundObject];
            [invocation setSelector:operation.boundSetter];
            [invocation setArgument:&tweenedValue atIndex:2];
            [invocation invoke];
        } else if (operation.boundRef) {
            *operation.boundRef = tweenedValue;
        }
        
    }
    
}

- (id)init {
    self = [super init];
    if (self != nil) {
        tweenOperations = [[NSMutableArray alloc] init];
        expiredTweenOperations = [[NSMutableArray alloc] init];
        timeOffset = 0;
        if (timer == nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:kPRTweenFramerate target:self selector:@selector(update) userInfo:nil repeats:YES];
        }
        self.defaultTimingFunction = &PRTweenTimingFunctionQuadInOut;
    }
    return self;
}

- (PRTweenOperation*)addTweenOperation:(PRTweenOperation*)operation {
    [tweenOperations addObject:operation];
    return operation;
}

#if NS_BLOCKS_AVAILABLE
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period 
                        updateBlock:(void (^)(PRTweenPeriod *period))updateBlock 
                    completionBlock:(void (^)())completeBlock {
    return [self addTweenPeriod:period updateBlock:updateBlock completionBlock:completeBlock timingFunction:self.defaultTimingFunction];
}

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period 
                        updateBlock:(void (^)(PRTweenPeriod *period))anUpdateBlock 
                    completionBlock:(void (^)())completeBlock 
                     timingFunction:(PRTweenTimingFunction)timingFunction {
    
    PRTweenOperation *tweenOperation = [[PRTweenOperation new] autorelease];
    tweenOperation.period = period;
    tweenOperation.timingFunction = timingFunction;
    tweenOperation.updateBlock = anUpdateBlock;
    tweenOperation.completeBlock = completeBlock;
    return [self addTweenOperation:tweenOperation];
    
}
#endif

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector {
    return [self addTweenPeriod:period target:target selector:selector timingFunction:self.defaultTimingFunction];
}

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(PRTweenTimingFunction)timingFunction {
    
    PRTweenOperation *tweenOperation = [[PRTweenOperation new] autorelease];
    tweenOperation.period = period;
    tweenOperation.target = target;
    tweenOperation.timingFunction = timingFunction;
    tweenOperation.updateSelector = selector;
    
    return [self addTweenOperation:tweenOperation];
    
}

- (void)removeTweenOperation:(PRTweenOperation *)tweenOperation {
    
    if (tweenOperation != nil && [tweenOperations containsObject:tweenOperation]) {
        [tweenOperations removeObject:tweenOperation];
    }
}

- (void)update {
    timeOffset += kPRTweenFramerate;
    
    for (PRTweenOperation *tweenOperation in tweenOperations) {
        
        PRTweenPeriod *period = tweenOperation.period;
        
        // if operation is delayed, pass over it for now
        if (timeOffset <= period.startOffset + period.delay) {
            continue;
        }
        
        CGFloat (*timingFunction)(CGFloat, CGFloat, CGFloat, CGFloat) = tweenOperation.timingFunction;
        
        if (timingFunction != NULL) {
            
            if (timeOffset <= period.startOffset + period.delay + period.duration) {
                if ([period isKindOfClass:[PRTweenLerpPeriod class]]) {
                    if ([period conformsToProtocol:@protocol(PRTweenLerpPeriod)]) {
                        PRTweenLerpPeriod <PRTweenLerpPeriod> *lerpPeriod = (PRTweenLerpPeriod <PRTweenLerpPeriod> *)period;
                        CGFloat progress = timingFunction(timeOffset - period.startOffset - period.delay, 0.0, 1.0, period.duration);
                        [lerpPeriod setProgress:progress];
                    } else {
                        // @TODO: Throw exception
                        NSLog(@"Class doesn't conform to PRTweenLerp");
                    }
                } else {
                    // if tween operation is valid, calculate tweened value using timing function
                    period.tweenedValue = timingFunction(timeOffset - period.startOffset - period.delay, period.startValue, period.endValue - period.startValue, period.duration);
                }
            } else {
                // move expired tween operations to list for cleanup
                period.tweenedValue = period.endValue;
                [expiredTweenOperations addObject:tweenOperation];
            }
            
            NSObject *target = tweenOperation.target;
            SEL selector = tweenOperation.updateSelector;
            
            if (period != nil) {
                if (target != nil && selector != NULL) {
                    [target performSelector:selector withObject:period afterDelay:0];    
                }
                
                // Check to see if blocks/GCD are supported
                if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) {
                    double delayInSeconds = 0.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        // fire off update block
                        if (tweenOperation.updateBlock != NULL) {
                            tweenOperation.updateBlock(period);
                        } 
                    });
                }
            }
        }
    }
    
    // clean up expired tween operations
    for (PRTweenOperation *tweenOperation in expiredTweenOperations) {
        if (tweenOperation.completeSelector) [tweenOperation.target performSelector:tweenOperation.completeSelector withObject:nil afterDelay:0];
        // Check to see if blocks/GCD are supported
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) {        
            if (tweenOperation.completeBlock != NULL) {
                tweenOperation.completeBlock();
            }
        }
        
        [tweenOperations removeObject:tweenOperation];
        
        // @HACK: Come up with a better pattern for removing observors.
        @try {
            [tweenOperation removeObserver:[PRTween sharedInstance] forKeyPath:@"period.tweenedValue"];
        } @catch (id exception) {
            
        }
        tweenOperation = nil;
    }
    [expiredTweenOperations removeAllObjects];
}

- (void)dealloc {
    [tweenOperations release];
    [expiredTweenOperations release];
    [timer invalidate];
    
    [super dealloc];
}

@end
