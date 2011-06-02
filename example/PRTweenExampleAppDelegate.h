//
//  JSTweenAppDelegate.h
//  JSTween
//
//  Created by Dominik Hofmann on 5/31/11.
//  Copyright 2011 Jetsetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRTweenExampleViewController;

@interface PRTweenExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet PRTweenExampleViewController *viewController;

@end
