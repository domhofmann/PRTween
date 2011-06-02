
#import "PRTween.h"

// These timing functions were ported from Robert Penner's AS2 easing equations.
// http://www.robertpenner.com/easing/

CGFloat PRTweenTimingFunctionLinear (CGFloat time, CGFloat begin, CGFloat change, CGFloat duration) {
    return change * time / duration + begin;
}

CGFloat PRTweenTimingFunctionBounceOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

CGFloat PRTweenTimingFunctionBounceIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c - PRTweenTimingFunctionBounceOut(d-t, 0, c, d) + b;
}

CGFloat PRTweenTimingFunctionBounceInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t < d/2) return PRTweenTimingFunctionBounceIn(t*2, 0, c, d) * .5 + b;
    else return PRTweenTimingFunctionBounceOut(t*2-d, 0, c, d) * .5 + c*.5 + b;
}

CGFloat PRTweenTimingFunctionQuintOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t*t*t + b;
}

CGFloat PRTweenTimingFunctionQuintIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
}

CGFloat PRTweenTimingFunctionQuintInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
}



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

- (NSDictionary*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector {
    return [self addTweenPeriod:period target:target selector:selector timingFunction:&PRTweenTimingFunctionLinear];
}

- (NSDictionary*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(CGFloat (*)(CGFloat, CGFloat, CGFloat, CGFloat))timingFunction {
    
    NSMutableDictionary *tweenOperation = [NSMutableDictionary dictionary];
    [tweenOperation setObject:period forKey:@"period"];
    [tweenOperation setObject:target forKey:@"target"];
    [tweenOperation setObject:[NSValue valueWithPointer:timingFunction] forKey:@"timingFunction"];
    [tweenOperation setObject:[NSValue valueWithBytes:&selector objCType:@encode(SEL)] forKey:@"selector"];
    [tweenOperations addObject:tweenOperation];
    
    return tweenOperation;
    
}

- (void)removeTweenOperation:(NSDictionary *)tweenOperation {
    
    if (tweenOperation != nil && [tweenOperations containsObject:tweenOperation]) {
        [tweenOperations removeObject:tweenOperation];
    }
}

- (void)update {
    timeOffset += kPRTweenFramerate;
    
    for (NSDictionary *tweenOperation in tweenOperations) {
        
        PRTweenPeriod *period = [tweenOperation valueForKey:@"period"];
        
        // if operation is delayed, pass over it for now
        if (timeOffset <= period.startOffset + period.delay) {
            continue;
        }
        
        CGFloat (*timingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);
        [[tweenOperation objectForKey:@"timingFunction"] getValue:&timingFunction];
        
        if (timingFunction != NULL) {
        
            if (timeOffset <= period.startOffset + period.delay + period.duration) {
                // if tween operation is valid, calculate tweened value using timing function
                period.tweenedValue = timingFunction(timeOffset - period.startOffset - period.delay, period.startValue, period.endValue - period.startValue, period.duration);
            } else {
                // move expired tween operations to list for cleanup
                period.tweenedValue = period.endValue;
                [expiredTweenOperations addObject:tweenOperation];
            }
            
            NSObject *target = [tweenOperation valueForKey:@"target"];
            SEL selector;
            
            // guard against buffer overflow
            if (strcmp([[tweenOperation objectForKey:@"selector"] objCType], @encode(SEL)) == 0) {
                [[tweenOperation objectForKey:@"selector"] getValue:&selector];
            }
            
            if (period != nil && target != nil && selector != NULL) {
                [target performSelector:selector withObject:period afterDelay:0];
            }
        }
    }
    
    // clean up expired tween operations
    for (NSDictionary *tweenOperation in expiredTweenOperations) {
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
