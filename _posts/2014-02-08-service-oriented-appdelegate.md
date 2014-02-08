---
layout: post
date: 2014-02-08 23:07:30 +0200
title: Service Oriented AppDelegate
---

Have you ever wished your `AppDelegate` wasn't so bloated when you integrate lots of different services into it? Social Media Libraries, Analytics, Debugging Tools and other services make your `AppDelegate` a lot larger than it should ideally be. I will show you how to overcome this problem and decouple your services away from your AppDelegate's implementation.

Based on several open source libraries and projects, I've found a much better way of organizing your integrations into **Services**, which are decoupled classes that keep your `AppDelegate` organized and neat.

The example we'll be using is very simple to keep this article easy to follow and understand. We'll be creating a `Service-Based AppDelegate` that handles **Push Notifications** outside of the main AppDelegate file.

Note that all of the service classes you will be creating are singleton classes since the way our AppDelegate works, is that it initializes them only once.

If this is a problem for you, maybe you need to re-think if the Service-Oriented AppDelegates actually work for your application architecture.

---

Let's start by creating a the Service-Oriented AppDelegate class, named `SOAppDelegate`, SO standing for Service-Oriented.

The class holds the list of *Services* that we will be using in the application, and the reference to the main application window. Simple.

```objc
// SOAppDelegate.h
#import <UIKit/UIKit.h>

@interface SOAppDelegate : UIResponder <UIApplicationDelegate>

// The list of services that will be integrated into our application lifecycle
- (NSArray *)services;

// Main window reference
@property (strong, nonatomic) UIWindow *window;

@end
```

The implementation of this class is fairly simple, but somewhat lengthy because we need to catch all of the application delegate methods for our services.

In some of the application delegate methods, we need to check the results of each service to make sure our delegate returns the proper values for it to work.

```objc
// SOAppdelegate.m
#import "SOAppDelegate.h"

@implementation SOAppDelegate

// By default, we'll have no services in the delegate
- (NSArray *)services {
	return nil;
}

#pragma mark - UIApplication Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    id<UIApplicationDelegate> service;
    // Loop through the current services and proxy the delegate call
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]){
            [service application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(applicationWillResignActive:)]){
            [service applicationWillResignActive:application];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(applicationDidEnterBackground:)]){
            [service applicationDidEnterBackground:application];
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(applicationWillEnterForeground:)]){
            [service applicationWillEnterForeground:application];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(applicationDidBecomeActive:)]){
            [service applicationDidBecomeActive:application];
        }
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(applicationWillTerminate:)]){
            [service applicationWillTerminate:application];
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    id<UIApplicationDelegate> service;
    BOOL result = NO;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]){
            result |= [service application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    id<UIApplicationDelegate> service;
    BOOL result = NO;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:handleOpenURL:)]){
            result |= [service application:application handleOpenURL:url];
        }
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]){
            [service application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]){
            [service application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:didReceiveLocalNotification:)]){
            [service application:application didReceiveLocalNotification:notification];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    id<UIApplicationDelegate> service;
    for(service in self.services){
        if ([service respondsToSelector:@selector(application:didReceiveRemoteNotification:)]){
            [service application:application didReceiveRemoteNotification:userInfo];
        }
    }
}

@end
```

Now that the delegate class is ready, we can create our first service! Create a new class called `PushNotificationService`.

```objc
// PushNotificationService.h
#import <Foundation/Foundation.h>

@interace PushNotificationService : NSObject <UIApplicationDelegate>

+ (instancetype)sharedInstance;

@end
```

For our Push Notification service to work properly, we need to do the following:

1. Register for the notifications upon application launch
2. Add push notification handlers

```objc
// PushNotificationService.m
#import "PushNotificationService.h"

@implementation PushNotificationService

// Singleton initializer
+ (instancetype)sharedInstance {
	static id _sharedInstance = nil;
	static dispatch_once_t _onceToken;
	dispatch_once(&_onceToken, ^{
		_sharedInstance = [[[self class] alloc] init];
	});
	return _sharedInstance;
}

// Tap into the application launch sequence and register for remote
// notifications.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Register for remote notifications
	[application registerForRemoteNotificationTypes:
		UIRemoteNotificationTypeBadge |
		UIRemoteNotificationTypeSound |
		UIRemoteNotificationTypeAlert];

	// If we launched from a remote notification, we'll pass the handler
	// to the notification handler method.
	if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
	}

	return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	// This method is called when the device successfully registers with the Apple Push Service
	NSLog(@"PushNotificationService Token: %@", [NSString stringWithUTF8String:deviceToken.bytes]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	// This method is called when the device failed to register with the Apply Push Service
    NSLog(@"PushNotificationService Error: %@", error.localizedDescription);
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	// Handler for the push notifications that we receive in our application
    NSLog(@"PushNotificationService Received: %@", userInfo);
}

@end
```

In our `PushNotificationService` example, we don't actually do anything with the push notifications, just so this article stays simple enough and doesn't get into the specifics of anything but the implementation of this Service-Based technique.

Our first service is now ready, and you can replace our `AppDelegate.h` with the following code:

```objc
// AppDelegate.h
#import "SOAppDelegate.h"

@interface AppDelegate : SOAppDelegate

@end
```

And the implementation of the AppDelegate is done in a very simple service-oriented style.

```objc
// AppDelegate.m
#import "PushNotificationService.h"

@implementation AppDelegate

// The services are only initialized once, via their singleton accessors
- (NSArray *)services {
	static NSArray * _services;
    static dispatch_once_t _onceTokenServices;
    dispatch_once(&_onceTokenServices, ^{
        _services = @[[PushNotificationService sharedInstance]];
    });
    return _services;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    // Initialize your view controllers and whatnot here

    return YES;
}

@end
```

Now when you launch your application, you will notice that the PushNotificationService is correctly tied into your AppDelegate, and responds to all the proper delegate methods sent by your application.