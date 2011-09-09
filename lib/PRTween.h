
#import <Foundation/Foundation.h>

#import "PRTweenTimingFunctions.h"

typedef CGFloat(*PRTweenTimingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);
#if NS_BLOCKS_AVAILABLE
@class PRTweenPeriod;
typedef void (^PRTweenUpdateBlock)(PRTweenPeriod *period);
typedef void (^PRTweenCompleteBlock)();
#endif

@interface PRTweenPeriod : NSObject {
    CGFloat duration;
    CGFloat delay;
    CGFloat startOffset;
    CGFloat startValue;
    CGFloat endValue;
    CGFloat tweenedValue;
}

@property (nonatomic) CGFloat startValue;
@property (nonatomic) CGFloat endValue;
@property (nonatomic) CGFloat tweenedValue;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGFloat startOffset;

+ (id)periodWithStartValue:(CGFloat)aStartValue endValue:(CGFloat)anEndValue duration:(CGFloat)duration;

@end

@protocol PRTweenLerpPeriod

- (NSValue*)tweenedValueForProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress;

@end

@interface PRTweenLerpPeriod : PRTweenPeriod {
    NSValue *startLerp;
    NSValue *endLerp;
    NSValue *tweenedLerp;
}

@property (nonatomic, copy) NSValue *startLerp;
@property (nonatomic, copy) NSValue *endLerp;
@property (nonatomic, copy) NSValue *tweenedLerp;

+ (id)periodWithStartValue:(NSValue*)aStartValue endValue:(NSValue*)anEndValue duration:(CGFloat)duration;

@end

@interface PRTweenCGPointLerpPeriod : PRTweenLerpPeriod <PRTweenLerpPeriod>
+ (id)periodWithStartCGPoint:(CGPoint)aStartPoint endCGPoint:(CGPoint)anEndPoint duration:(CGFloat)duration;
- (CGPoint)startCGPoint;
- (CGPoint)tweenedCGPoint;
- (CGPoint)endCGPoint;
@end

@interface PRTweenCGRectLerpPeriod : PRTweenLerpPeriod <PRTweenLerpPeriod>
+ (id)periodWithStartCGRect:(CGRect)aStartRect endCGRect:(CGRect)anEndRect duration:(CGFloat)duration;
- (CGRect)startCGRect;
- (CGRect)tweenedCGRect;
- (CGRect)endCGRect;
@end

@interface PRTweenOperation : NSObject {
    PRTweenPeriod *period;
    NSObject *target;
    SEL updateSelector;
    SEL completeSelector;
    PRTweenTimingFunction timingFunction;
    
    CGFloat *boundRef;
    SEL boundGetter;
    SEL boundSetter;
    
    BOOL usesBuiltInAnimation;
    
#if NS_BLOCKS_AVAILABLE
    PRTweenUpdateBlock updateBlock;
    PRTweenCompleteBlock completeBlock; 
#endif
}

@property (nonatomic, retain) PRTweenPeriod *period;
@property (nonatomic, retain) NSObject *target;
@property (nonatomic) SEL updateSelector;
@property (nonatomic) SEL completeSelector;
@property (nonatomic, assign) PRTweenTimingFunction timingFunction;

#if NS_BLOCKS_AVAILABLE
@property (nonatomic, copy) PRTweenUpdateBlock updateBlock;
@property (nonatomic, copy) PRTweenCompleteBlock completeBlock;
#endif

@property (nonatomic, assign) CGFloat *boundRef;
@property (nonatomic, retain) id boundObject;
@property (nonatomic) SEL boundGetter;
@property (nonatomic) SEL boundSetter;
@property (nonatomic) BOOL usesBuiltInAnimation;

@end

@interface PRTweenCGPointLerp : NSObject
+ (void)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (void)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
#if NS_BLOCKS_AVAILABLE
+ (void)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;
#endif
@end

@interface PRTweenCGRectLerp : NSObject
+ (void)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (void)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration;
#if NS_BLOCKS_AVAILABLE
+ (void)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;
#endif
@end

@interface PRTween : NSObject {
    NSMutableArray *tweenOperations;
    NSMutableArray *expiredTweenOperations;
    NSTimer *timer;
    CGFloat timeOffset;
    
    PRTweenTimingFunction defaultTimingFunction;
    BOOL useBuiltInAnimationsWhenPossible;
}

@property (nonatomic, readonly) CGFloat timeOffset;
@property (nonatomic, assign) PRTweenTimingFunction defaultTimingFunction;
@property (nonatomic, assign) BOOL useBuiltInAnimationsWhenPossible;

+ (PRTween *)sharedInstance;

+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector;

+ (void)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector;

+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration;

+ (void)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration;

+ (void)lerp:(id)object property:(NSString*)property period:(PRTweenLerpPeriod <PRTweenLerpPeriod> *)period timingFunction:(PRTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;

- (PRTweenOperation*)addTweenOperation:(PRTweenOperation*)operation;
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector;
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(PRTweenTimingFunction)timingFunction;
- (void)removeTweenOperation:(PRTweenOperation*)tweenOperation;

#if NS_BLOCKS_AVAILABLE
+ (void)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;

+ (void)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;

+ (void)lerp:(id)object property:(NSString*)property period:(PRTweenLerpPeriod <PRTweenLerpPeriod> *)period timingFunction:(PRTweenTimingFunction)timingFunction updateBlock:(PRTweenUpdateBlock)updateBlock completeBlock:(PRTweenCompleteBlock)completeBlock;

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period updateBlock:(PRTweenUpdateBlock)updateBlock completionBlock:(PRTweenCompleteBlock)completeBlock;
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period updateBlock:(PRTweenUpdateBlock)updateBlock completionBlock:(PRTweenCompleteBlock)completionBlock timingFunction:(PRTweenTimingFunction)timingFunction;
#endif

@end
