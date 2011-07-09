
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

- (void)dealloc {
    [super dealloc];
}

@end

@implementation PRTweenOperation
@synthesize period;
@synthesize target;
@synthesize updateSelector;
@synthesize completeSelector;
@synthesize timingFunction;
@end

@interface PRTween ()
- (void)update;
@end

static PRTween *instance;

@implementation PRTween
@synthesize timeOffset;

+ (PRTween *)sharedInstance {
    if (instance == nil) {
        instance = [[PRTween alloc] init];
    }
    return instance;
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
    }
    return self;
}

- (PRTweenOperation*)addOperation:(PRTweenOperation*)operation {
    [tweenOperations addObject:operation];
    return operation;
}

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector {
    return [self addTweenPeriod:period target:target selector:selector timingFunction:&PRTweenTimingFunctionLinear];
}

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(CGFloat (*)(CGFloat, CGFloat, CGFloat, CGFloat))timingFunction {
    
    PRTweenOperation *tweenOperation = [[PRTweenOperation new] autorelease];
    tweenOperation.period = period;
    tweenOperation.target = target;
    tweenOperation.timingFunction = timingFunction;
    tweenOperation.updateSelector = selector;
    
    return [self addOperation:tweenOperation];
    
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
                // if tween operation is valid, calculate tweened value using timing function
                period.tweenedValue = timingFunction(timeOffset - period.startOffset - period.delay, period.startValue, period.endValue - period.startValue, period.duration);
            } else {
                // move expired tween operations to list for cleanup
                period.tweenedValue = period.endValue;
                [expiredTweenOperations addObject:tweenOperation];
            }
            
            NSObject *target = tweenOperation.target;
            SEL selector = tweenOperation.updateSelector;
            
            if (period != nil && target != nil && selector != NULL) {
                [target performSelector:selector withObject:period afterDelay:0];
            }
        }
    }
    
    // clean up expired tween operations
    for (PRTweenOperation *tweenOperation in expiredTweenOperations) {
        if (tweenOperation.completeSelector) [tweenOperation.target performSelector:tweenOperation.completeSelector withObject:nil afterDelay:0];
        [tweenOperations removeObject:tweenOperation];
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
