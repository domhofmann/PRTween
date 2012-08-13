
#import "PRTweenExampleViewController.h"

@implementation PRTweenExampleViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:testView];
    
}

- (void)update:(PRTweenPeriod*)period {
    if ([period isKindOfClass:[PRTweenCGPointLerpPeriod class]]) {
        testView.center = [(PRTweenCGPointLerpPeriod*)period tweenedCGPoint];
    } else {
        testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
    }
}

- (IBAction)defaultTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:1.5];
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:)];        
}

- (IBAction)bounceOutTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:1.5];
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&PRTweenTimingFunctionBounceOut];        
}

- (IBAction)bounceInTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:1.5];
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&PRTweenTimingFunctionBounceIn];
}

- (IBAction)quintOutTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:1.5];
    period.delay = 1.5;
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&PRTweenTimingFunctionQuintOut];
}

- (IBAction)pointLerpTapped {
    activeTweenOperation = [PRTweenCGPointLerp lerp:testView property:@"center" from:CGPointMake(50, 50) to:CGPointMake(400, 400) duration:1.5];
}

- (IBAction)rectLerpTapped {
    activeTweenOperation = [PRTweenCGRectLerp lerp:testView property:@"frame" from:CGRectMake(0, 0, 100, 100) to:CGRectMake(100, 100, 250, 250) duration:3 timingFunction:&PRTweenTimingFunctionElasticOut target:nil completeSelector:NULL];
}

- (IBAction)verboseTapped {
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0 endValue:904 duration:1.5];
    PRTweenOperation *operation = [PRTweenOperation new];
    operation.period = period;
    operation.timingFunction = &PRTweenTimingFunctionQuartOut;
    operation.target = self;
    operation.updateSelector = @selector(update:);
    
    [[PRTween sharedInstance] addTweenOperation:operation];
    activeTweenOperation = operation;
}

- (IBAction)blockTapped {
     activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:[PRTweenPeriod periodWithStartValue:0 endValue:904 duration:1.5] updateBlock:^(PRTweenPeriod *period) {
     testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
     } completionBlock:^(void) {
         NSLog(@"Completed tween");
     }];
}

- (IBAction)shorthandTapped {
    activeTweenOperation = [PRTweenCGPointLerp lerp:testView property:@"center" from:CGPointMake(50, 50) to:CGPointMake(250, 250) duration:1.5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    testView = nil;
}

@end
