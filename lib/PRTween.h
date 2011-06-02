
#import <Foundation/Foundation.h>

CGFloat PRTweenTimingFunctionLinear (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionBounceOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionBounceIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionBounceInOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionQuintOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionQuintIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat PRTweenTimingFunctionQuintInOut (CGFloat, CGFloat, CGFloat, CGFloat);

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

@interface PRTween : NSObject {
    NSMutableArray *tweenOperations;
    NSMutableArray *expiredTweenOperations;
    NSTimer *timer;
    CGFloat timeOffset;
}

@property (nonatomic, readonly) CGFloat timeOffset;

+ (PRTween *)sharedInstance;
- (NSDictionary*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector;
- (NSDictionary*)addTweenPeriod:(PRTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(CGFloat (*)(CGFloat, CGFloat, CGFloat, CGFloat))timingFunction;
- (void)removeTweenOperation:(NSDictionary*)tweenOperation;

@end
