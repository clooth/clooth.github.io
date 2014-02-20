---
layout: post
date: 2014-02-20 19:11:47 +0200
title: Snap webcam photos whenever your app crashes
tags: [xcode, experiment, webcam]
published: true
---

I decided to try something even funnier with capturing your expressions when developing applications.

What is your expression when your application borks out and throws an exception? Let's see!

<!-- more -->

To start, we do what we did in the first article: Install the [imagesnap](https://github.com/rharder/imagesnap) library from [homebrew](http://brew.sh):

```bash
brew install imagesnap
```

And once that's done, we do something a bit different in our Xcode project. We won't be adding a Run Script build phase, but instead a custom exception breakpoint to capture our photo.

Once your project is open, navigate to the breakpoints sidebar menu on the left, and add a new **Exception Breakpoint** breakpoint by clicking on the `+` icon on the bottom left.

![Adding the breakpoint](http://cl.ly/U29E/Screen%20Shot%202014-02-20%20at%2019.17.59.png)

Set the added breakpoint to only capture Objective-C exceptions, and optionally to continue evaluation after the breakpoint is reached.

Change the `Action` menu to `AppleScript`, and put the following text into the script box:

```applescript
set photoPath to "~/Pictures/BuildPhotos/$(date +%y%m%d%H%M%S).png"
do shell script "/usr/local/bin/imagesnap " & photoPath
```

**Note:** If you installed imagesnap somewhere else, or have your own folder for the photos, be sure to change the paths in the script, or it just won't work.

The breakpoint should now look something like this:

![Finished breakpoint](http://cl.ly/U1xX/Screen%20Shot%202014-02-20%20at%2019.51.28.png)

To test the capturing, you can add two lines to our AppDelegate (or any file you want, really) to trigger an objective-c exception, in this case an index out of bounds exception:

```objc
    NSArray *array = @[@"WHY", @"SO", @"SERIOUS"];
    NSLog(@"%@", array[9001]);
```

Run your app. Smile for the camera. And you're done!

![God damnit](http://cl.ly/U1w0/fuuu.png)