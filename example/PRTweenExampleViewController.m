
#import "PRTweenExampleViewController.h"
#import "PRTween.h"

@implementation PRTweenExampleViewController

- (void)dealloc
{
    [testView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    testView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:testView];

}

- (void)update:(PRTweenPeriod*)period {
    testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
}

- (IBAction)linearTapped {
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

- (IBAction)bounceOutDelayTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:1.5];
    period.delay = 1.5;
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&PRTweenTimingFunctionBounceOut];
}

- (IBAction)quintOutTapped {
    [[PRTween sharedInstance] removeTweenOperation:activeTweenOperation];
    
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:0.0 endValue:904 duration:0.6];
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&PRTweenTimingFunctionQuintOut];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [testView release];
}

@end
