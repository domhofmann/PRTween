
#import <UIKit/UIKit.h>
#import "PRTween.h"

@interface PRTweenExampleViewController : UIViewController {
    
    UIView *testView;
    PRTweenOperation *activeTweenOperation;
    
}

- (IBAction)linearTapped;
- (IBAction)bounceOutTapped;
- (IBAction)bounceInTapped;
- (IBAction)bounceOutDelayTapped;
- (IBAction)quintOutTapped;

@end
