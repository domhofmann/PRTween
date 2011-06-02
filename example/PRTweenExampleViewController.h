//
//  JSTweenViewController.h
//  JSTween
//
//  Created by Dominik Hofmann on 5/31/11.
//  Copyright 2011 Jetsetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRTweenExampleViewController : UIViewController {
    
    UIView *testView;
    NSDictionary *activeTweenOperation;
    
}

- (IBAction)linearTapped;
- (IBAction)bounceOutTapped;
- (IBAction)bounceInTapped;
- (IBAction)bounceOutDelayTapped;
- (IBAction)quintOutTapped;

@end
