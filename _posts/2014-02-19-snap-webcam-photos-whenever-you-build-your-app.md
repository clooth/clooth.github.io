---
layout: post
date: 2014-02-19 20:22:13 +0200
title: Snap webcam photos whenever you build your app
tags: [xcode, experiment, webcam]
published: true
---

This is more of a fun experiment I wanted to try out today than anything signifigantly useful.

The goal: Take my photo whenever I build my application in Xcode.

<!-- more -->

First, install the [imagesnap](https://github.com/rharder/imagesnap) library from [homebrew](http://brew.sh):

```bash
brew install imagesnap
```

Once all is good, open your project in Xcode, and add a new `Run Script` Build Phase.

**Make sure to change the `~/Pictures/BuildPhotos/` to whatever directory you want to save your photos into.**

```
imagesnap ~/Pictures/BuildPhotos/$(date +%y%m%d%H%M%S).png
```

![XCode Run Script Build Phase](http://cl.ly/Tzyw/Screen%20Shot%202014-02-19%20at%2020.34.11.png)

**Now build your app!**

![Meeee!](http://cl.ly/U0ur/140219203741%20copy.png)

---

All the photos will be timestamped, so the order will be logical if you plan on doing something with the photos :)