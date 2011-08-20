PRTween
===

PRTween is a lightweight tweening library built for iOS. While Apple has done an incredible job with UIView Animations and Core Animation, there are some conscious limitations in these systems that are difficult to get around. PRTween is a great alternative if you'd like to:

* Animate a property Apple won't allow you to
* Ensure that `[someView layoutSubviews]` is respected during an animation
* Tween arbitrary numerical values, such as sound volume, scroll position, a counter, or many others
* Define your timing curve as a function rather than a bezier with control points

Installation
===

Simply grab the PRTween and PRTweenTimingFunction files from /lib/ and get them into your project.

Usage
===

At its core, PRTween is broken into two components.

A **period** is a representation of three points in time (beginning, current, and end) for a particular value that you plan on tweening. For example, suppose that are tweening a value from 100 to 200 over the course of 3 seconds. You can create an object to represent that period like this:

	PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:100 endValue:200 duration:3];
	
The second component that makes up PRTween is an **operation**. An operation contains logistic information about how a period should play out, as well as what should happen while it does. You can think of a period as an abstract representation of work that should be carried out, and an operation as the worker who decides *how* it gets carried out. An operation might look like this:
	 
	PRTweenOperation *operation = [[PRTweenOperation new] autorelease];
	operation.period = period;
	operation.target = self;
	operation.timingFunction = &PRTweenTimingFunctionLinear;
	operation.updateSelector = @selector(update:)

The code above creates a new operation that carries out a tween over the period we defined earlier. Additionally, you've told the operation to call the `update:` selector on `self` every time the value is adjusted. `update:` might look like this:

	- (void)update:(PRTweenPeriod*)period {
		NSLog(@"%f", period.tweenedValue);
	}
	
Finally, you will need to add the operation to the queue.

	[[PRTween sharedInstance] addTweenOperation:operation]
	
As soon as you've done this and run your code, you should be able to see a console trace of a value moving from 100 to 200 over the course of 3 seconds. If you wanted to apply this to an object on screen, it could be as simple as changing `update:` to the following:

	// will animate the Y offset of testView from 100 to 200 over the course of 3 seconds
	- (void)update:(PRTweenPeriod*)period {
	    testView.frame = CGRectMake(0, period.tweenedValue, 100, 100);
	}
	
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

Custom Functions
---

One of the most powerful capabilities of PRTween is the ability to write your own timing functions. In lieu of documentation at this time, have a look through PRTweenTimingFunctions.m for example timing functions.

Advanced
===

API docs are coming with the next push. Until then, you are encouraged to dig through the code for details on advanced functionality. PRTween is incredibly minimal, so you can probably figure everything out in an hour or two.

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

