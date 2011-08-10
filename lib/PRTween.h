
#import <Foundation/Foundation.h>

#import "PRTweenTimingFunctions.h"

@interface PRTweenPeriod : NSObject {
    CGFloat startValue;
    CGFloat endValue;
    CGFloat tweenedValue;
    CGFloat duration;
    CGFloat delay;
    CGFloat startOffset;
}

@property (nonatomic) CGFloat startValue;
@property (nonatomic) CGFloat endValue;
@property (nonatomic) CGFloat tweenedValue;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGFloat startOffset;

+ (id)periodWithStartValue:(CGFloat)aStartValue endValue:(CGFloat)anEndValue duration:(CGFloat)duration;

@end

@interface PRTweenOperation : NSObject {
    PRTweenPeriod *period;
    NSObject *target;
    SEL updateSelector;
    SEL completeSelector;
    CGFloat (*timingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);
    
#if NS_BLOCKS_AVAILABLE
    void (^completionBlock)();
    void (^updateBlock)(PRTweenPeriod *period);    
#endif
}

@property (nonatomic, retain) PRTweenPeriod *period;
@property (nonatomic, retain) NSObject *target;
@property (nonatomic) SEL updateSelector;
@property (nonatomic) SEL completeSelector;
@property (nonatomic, assign) CGFloat (*timingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);

#if NS_BLOCKS_AVAILABLE
@property (nonatomic, copy) void (^updateBlock)(PRTweenPeriod *period);
@property (nonatomic, copy) void (^completionBlock)();
#endif

@end

@interface PRTween : NSObject {
    NSMutableArray *tweenOperations;
    NSMutableArray *expiredTweenOperations;
    NSTimer *timer;
    CGFloat timeOffset;
}

@property (nonatomic, readonly) CGFloat timeOffset;

+ (PRTween *)sharedInstance;
- (PRTweenOperation*)addOperation:(PRTweenOperation*)operation;

#if NS_BLOCKS_AVAILABLE
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period updateBlock:(void (^)(PRTweenPeriod *period))updateBlock completionBlock:(void (^)())completionBlock;
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period updateBlock:(void (^)(PRTweenPeriod *period))updateBlock completionBlock:(void (^)())completionBlock timingFunction:(CGFloat (*)(CGFloat, CGFloat, CGFloat, CGFloat))timingFunction;
#endif

- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector;
- (PRTweenOperation*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(CGFloat (*)(CGFloat, CGFloat, CGFloat, CGFloat))timingFunction;
- (void)removeTweenOperation:(PRTweenOperation*)tweenOperation;

@end
