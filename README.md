PRTween
===

PRTween is a lightweight tweening library built for iOS. While Apple has done an incredible job with UIView Animations and Core Animation, there are sometimes cases that are difficult to get around. PRTween is a great alternative if you'd like to:

* Animate a property Core Animation won't allow you to
* Ensure that `[someView layoutSubviews]` is respected during an animation
* Tween arbitrary numerical values, such as sound volume, scroll position, a counter, or many others
* Define your timing curve as a function rather than a bezier with control points

PRTween aims to be as simple as possible without sacrificing flexibility. In many cases, an animation may be as simple as:

```objective-c
[PRTween tween:someView property:@"alpha" from:1 to:0 duration:3];
```

In order to promote simplicity, PRTween can be used as a drop-in replacement for most animations in your app. This means that in the case displayed above, the end result is identical to writing a UIView animation yourself.

Status
===

So alpha. Seriously.

Installation
===

Simply grab the PRTween and PRTweenTimingFunction files from /lib/ and get them into your project.

Usage
===

At its core, PRTween is broken into two components.

A **period** is a representation of three points in time (beginning, current, and end) for a particular value that you plan on tweening. For example, suppose that you are tweening a value from 100 to 200 over the course of 3 seconds. You can create an object to represent that period like this:

```objective-c
PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:100 endValue:200 duration:3];
```
	
The second component that makes up PRTween is an **operation**. An operation contains logistic information about how a period should play out, as well as what should happen while it does. You can think of a period as an abstract representation of work that should be carried out, and an operation as the worker who decides *how* it gets carried out. An operation might look like this:

```objective-c	 
PRTweenOperation *operation = [[PRTweenOperation new] autorelease];
operation.period = period;
operation.target = self;
operation.timingFunction = &PRTweenTimingFunctionLinear;
operation.updateSelector = @selector(update:)
```

The code above creates a new operation that carries out a tween over the period we defined earlier. Additionally, you've told the operation to call the `update:` selector on `self` every time the value is adjusted. `update:` might look like this:

```objective-c
- (void)update:(PRTweenPeriod*)period {
	NSLog(@"%f", period.tweenedValue);
}
```

Finally, you will need to add the operation to the queue.

```objective-c
[[PRTween sharedInstance] addTweenOperation:operation]
```
	
As soon as you've done this and run your code, you should be able to see a console trace of a value moving from 100 to 200 over the course of 3 seconds. If you wanted to apply this to an object on screen, it could be as simple as changing `update:` to the following:

```objective-c
// will animate the Y offset of testView from 100 to 200 over the course of 3 seconds
- (void)update:(PRTweenPeriod*)period {
    testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
}
```
	
Timing Functions
===

Timing functions are a key feature of PRTween, and allow you to modify how an operation interprets a period. For example, try changing `operation.timingFunction` from `&PRTweenTimingFunctionLinear` to `&PRTweenTimingFunctionBounceOut` and running your code again. You should see a similar animation play out, but this time a bounce will be added to the end of it. PRTween comes bundled with a number of timing functions for your convenience:

* PRTweenTimingFunctionLinear 
* PRTweenTimingFunctionBack*[In / Out / InOut]*
* PRTweenTimingFunctionBounce*[In / Out / InOut]*
* PRTweenTimingFunctionCirc*[In / Out / InOut]*
* PRTweenTimingFunctionCubic*[In / Out / InOut]*
* PRTweenTimingFunctionElastic*[In / Out / InOut]*
* PRTweenTimingFunctionExpo*[In / Out / InOut]*
* PRTweenTimingFunctionQuad*[In / Out / InOut]*
* PRTweenTimingFunctionQuart*[In / Out / InOut]*
* PRTweenTimingFunctionQuint*[In / Out / InOut]*
* PRTweenTimingFunctionSine*[In / Out / InOut]*

You should take some time to experiment with PRTween's timing functions in your applications to see which ones you like best.

Whenever `timingFunction` is omitted from a tween in PRTween, the default timing function is used. This is accessible through the `defaultTimingFunction` property on `PRTween`, although you will generally access it through `[PRTween sharedInstance].defaultTimingFunction`.

Custom Functions
---

One of the most powerful capabilities of PRTween is the ability to write your own timing functions. In lieu of documentation at this time, have a look through PRTweenTimingFunctions.m for example timing functions.

Shorthand
===

The code in the examples above is far from unwieldy, but it could still stand to be simplified. For the most common cases, PRTween offers **shorthand** functionality to reduce the amount of code that needs to be written.

For example, a simple alpha tween may be written concisely as:

```objective-c
[PRTween tween:testView property:@"alpha" from:1 to:0 duration:3];
```

You can also directly tween values that might not be properties. Suppose you're developing a game that has a scrollPosition `CGFloat`:

```objective-c
[PRTween tween:&scrollPosition from:0 to:20 duration:3];
```

PRTween currently supports the following base shorthands:

```objective-c
// for properties on objects
[PRTween tween:property:from:to:duration:timingFunction:target:completeSelector:]
[PRTween tween:property:from:to:duration:]

// for values
[PRTween tween:from:to:duration:timingFunction:target:completeSelector:]
[PRTween tween:from:to:duration:]
```
	
PRTween also supports shorthands for blocks and lerps, explained below.

Fallbacks
===

In many cases, the UIView or Core Animation functionality bundled with iOS  will do the job just fine. PRTween attempts to be intelligent about this, and will use a **fallback** for any property that can be animated by UIView or Core Animation.

For example, writing this code in PRTween:

```objective-c
[PRTween tween:someView property:@"alpha" from:1 to:0 duration:3];
```

Is identical to writing this code without PRTween:

```objective-c
someView.alpha = 1;
[UIView beginAnimations:nil context:NULL];
[UIView setAnimationDuration:3];
someView.alpha = 0;
[UIView commitAnimations];
```

Fallbacks can be disabled on a **case-by-case** basis with the following syntax:

```objective-c
[PRTween tween:someView property:@"alpha" from:1 to:0 duration:2].override = YES;
```

Or **globally**:

```objective-c
[PRTween sharedInstance].useBuiltInAnimationsWhenPossible = NO;
```

The following _UIView_ properties are eligible for UIView fallbacks:

* frame
* bounds
* center
* transform
* alpha
* contentStretch

The following _CALayer_ properties are eligible Core Animation fallbacks:

* bounds
* position
* zPosition
* anchorPoint
* anchorPointZ
* frame
* contentsRect
* contentsScale
* contentsCenter
* cornerRadius
* borderWidth
* opacity
* shadowOpacity
* shadowOffset
* shadowRadius

Support for CGColor, CGPath, and CATransform3D properties for fallbacks is forthcoming.

Note the **using an unsupported timing function will disqualify an animation** that was eligible for fallbacks. Only the built-in curves bundled with iOS are supported for fallbacks. They can be accessed through the following:

* PRTweenTimingFunctionCALinear
* PRTweenTimingFunctionCAEaseIn
* PRTweenTimingFunctionCAEaseOut
* PRTweenTimingFunctionCAEaseInOut
* PRTweenTimingFunctionCADefault                                 
* PRTweenTimingFunctionUIViewLinear
* PRTweenTimingFunctionUIViewEaseIn
* PRTweenTimingFunctionUIViewEaseOut
* PRTweenTimingFunctionUIViewEaseInOut

Blocks
===

If you are targeting iOS 4 or greater, you can take advantage of blocks when using PRTween. Blocks are particularly useful for keeping all your code in one place. For example, we could remove the `update:` method from the example above, and replace it with the following line in our declaration of `operation`:

```objective-c
operation.updateBlock = ^(PRTweenPeriod *period) {
    testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
};
```
	
You can also use blocks to execute code after the animation is complete.

```objective-c
operation.completeBlock = ^{
	NSLog("@All done!")
};
```
	
Blocks are also available on shorthands:

```objective-c
// for properties on objects
[PRTween tween:property:from:to:duration:timingFunction:updateBlock:completeBlock]

// for values
[PRTween tween:from:to:duration:timingFunction:updateBlock:completeBlock]
```
	
Lerps
===

Sometimes you will find it necessary to animate a complex value, such as a `CGPoint`. Although you could write two tweens for the `x` and `y` fields, it is much simpler to use linear interpolation, or **lerps**. In PRTween, a lerp is differentiated from a normal tween by using a `PRTweenLerpPeriod`. For example, we might change our declaration of `period` above:

```objective-c
PRTweenCGPointLerpPeriod *period = [PRTweenCGPointLerpPeriod periodWithStartCGPoint:CGPointMake(0, 0) endCGPoint:CGPointMake(100, 100) duration:2];
```

PRTween currently has built-in lerps for `CGPoint` and `CGRect` and `CGSize` through `PRTweenCGPointLerpPeriod`, `PRTweenCGRectLerpPeriod` and `PRTweenCGSizeLerpPeriod`. Lerps are also available as shorthands:

```objective-c
// for CGPoint
[PRTweenCGPointLerp lerp:property:from:to:duration:timingFunction:target:completeSelector:]
[PRTweenCGPointLerp lerp:property:from:to:duration:]

// for CGSize
[PRTweenCGSizeLerp lerp:property:from:to:duration:timingFunction:target:completeSelector:]
[PRTweenCGSizeLerp lerp:property:from:to:duration:]

// for CGRect
[PRTweenCGRectLerp lerp:property:from:to:duration:timingFunction:target:completeSelector:]
[PRTweenCGRectLerp lerp:property:from:to:duration:]


// blocks for iOS 4 or greater
[PRTweenCGPointLerp lerp:property:from:to:duration:timingFunction:target:updateBlock:completeBlock:]
[PRTweenCGSizeLerp lerp:property:from:to:duration:timingFunction:target:updateBlock:completeBlock:]
[PRTweenCGRectLerp lerp:property:from:to:duration:timingFunction:target:updateBlock:completeBlock:]
```

Custom Lerps
---

One of the most powerful features of PRTween is its ability to use custom lerps. In general, classes that subclass `PRTweenLerpPeriod` and implement the `<PRTweenLerpPeriod>` protocol may be used as custom lerps. This allows us to tween any complex numerical value with ease. Documentation is forthcoming, but for now you can check the code behind `PRTweenCGPointLerpPeriod` for more details.

Advanced
===

API docs are coming shortly. Until then, you are encouraged to dig through the code for details on advanced functionality. PRTween is very minimal, so you can probably figure everything out in an hour or two.

Contributing
===

PRTween is incredibly young, so there aren't many rules right now.

* Fork it
* Fix it or add it
* Add yourself to the contributor list
* Commit
* Send a pull request

Contributors
---

* [Dominik Hofmann](https://github.com/dominikhofmann/)
* [Matt Herzog](https://github.com/mattherzog/)
* [Robert Brisita](https://github.com/transmitiveRB/)
* [Ludwig Schubert](https://github.com/ludwigschubert)

License
===
Surprise! It's a BSD license.

<pre>
Copyright (c) 2011, Dominik Hofmann
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
</pre>

