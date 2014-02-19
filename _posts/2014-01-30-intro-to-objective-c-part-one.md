---
layout: post
date: 2014-01-30 13:33:06 +0200
title: Intro to Objective-C - Part One
tags: objective-c ios osx languages
published: true
---

In this series of articles we'll set up a foundation for understanding and writing Objective-C code. We will also look at working with some of the most basic frameworks provided by Apple.

In the later parts of the series we'll be taking a close look at the more advanced techniques used when programming iOS applications with Objective-C.

I hope you enjoy reading as much as I did writing this!

<!-- more -->

**Disclaimer:** This is one of my first articles on Objective-C, and I don't consider myself a true expert of the language. If you happen to find an error, or have a differing opinion, please don't hesitate to contact me and we'll see what can be improved or fixed!

### What is Objective-C?

Objective-C is, in it's simplest form, a superset of the C language with smalltalk/lisp like object orientation. It consists of a small set of extensions which turn C into an object-oriented language.

It was designed by Brad Cox and Tom Love back in the early 1980s, and has since evolved into the primary language for Apple iOS and Mac application development. OS X and iOS themselves are partially developed in Objective-C.

#### Frameworks

It is almost always used with two object-oriented frameworks:

- The **Foundation** framework contains classes for basic data structures like strings and arrays, and provides classes to interact with the underlying system.

- The **AppKit** framework contains classes for developing applications on the Mac operating system, creating windows, buttons and other widgets.

These two frameworks, when combined, are called **Cocoa**, which you might of heard of.

On the iOS platform, the **AppKit** framework is replaced by the **UIKit** framework and is called **Cocoa Touch** when used with **Foundation**.

#### The C language

Any knowledge you might have about the C language is directly relevant to programming in Objective-C, statements, data types, structs, etc. are still there and usable in your applications.

The additions to C from Objective-C are there to help you more easily work with structs, memory management and other normally tedious tasks.

---

### Development Tools

#### Xcode

The most common editor for Objective-C code is Apple's Xcode IDE, which gives you a massive amount of useful tools to help you write a) better b) faster code.

Xcode uses either gcc or Apple's own LLVM compilers in the background, depending on the settings of your project. Many different aspects of the application build phase can be configured from within Xcode.

##### Installing Xcode

Xcode is available on the Mac App Store and is 100% free for the users of the OS X Lion or newer.

After downloading Xcode from the App Store, you will have a file called _Install Xcode_ in your Applications folder, which when run, installs the editor and the tools required to work with it.

I recommend you to download and install Xcode now so that you can try out the code examples I'll be giving you later on.

#### Jetbrains AppCode

Another, while a fairly new project is the AppCode IDE from Jetbrains. I don't personally have any experience in using AppCode for projects, but from what I've heard there are both good and bad sides to it. The biggest bad side is that it costs $199 for a commercial and $99 for an indie license. It's completely free for Open Source projects though.

This article will be assuming you're working with Xcode, but if you're interested you can check out AppCode on its website below.

http://www.jetbrains.com/objc/

---

### Objective-C Basics

In this section we'll take a quick look at how objective-c code is different from C and how code is usually structured in applications.

#### Files

When working with Objective-C code, you will be mostly working with two types of files, the `.h` interface files, and the `.m` implementation files.

Just like in C, the interface files contain the declarations for our data, and the implementation files contain the definitions of what the values are, and how the declared things are actually done.

#### Classes

When writing applications with Objective-C, you will most likely be working with Classes.

Classes are just a container for underlying objects, and make writing your application a lot easier because you can separate and structure your code very neatly.

##### Basic Class Interface

A basic interface for a Book class looks like the following:

```objc
#import <Foundation/Foundation.h>

@interface Book : NSObject

@end
```

This goes into a file called `Book.h`, and in the example we have a class called `Book` that inherits from the `NSObject` class (which we get from the #imported Foundation framework). Public properties and methods are defined within this interface, but for the sake of a simple example we don't define anything here. The only functionality this class has is that inherited from `NSObject`.

All classes in Objective-C must have unique names. A common naming practice in your own classes is to prefix them with your own, the project's, or your company's initials. In my case the above class could be called `NHBook` to separate it from other Book classes. The prefixes `UI` and `NS` are reserved for Apple's frameworks.

###### Declaring Properties

Classes often have properties that are meant to be publicly accessible. For our `Book` class example, these properties could be the title and author of the book.

In our interface we would declare those properties like this:

```objc
#import <Foundation/Foundation.h>

@interface Book : NSObject

@property NSString *title;
@property NSString *authorName;

@end
```

Both of these properties are of the `NSString` type. `NSString` is part of the *Foundation* framework, a class that declares an object for immutable strings. It is a simple wrapper for C-strings with added methods for working with strings more easily.

Now, we need some more properties for our book, so add a few other ones:

```objc
@property NSDate   *publishedDate;
@property NSNumber *pageCount;
```

Here we introduce two new types of objects, the `NSDate` object which stores a date and time value, and the `NSNumber` which stores a generic numeric value.

In case you're storing simpler numerical values, you can always fall back to the basic C int, float, double etc. values. Just remember to remove the asterix since the values are scalar and not pointers!

###### Property Attributes

If you need to make a property not writeable by the public, you would add **property attributes** to your properties to indicate just that. For example if we wanted to make the `publishedDate` property not writeable, we would make it look like this instead:

```objc
@property (readonly) NSDate *publishedDate;
```

Pretty straightforward! All property attributes are defined within the parenthesis right after the @property clause.

###### Declaring Methods

Method declarations in a class's interface define the "messages" an object can receive.

What kind of messages do you think our `Book` class could or should receive? Turning pages? Getting reviews?  It is possible that the class doesn't need any behaviour or methods, but in our case, let's implement a few.

In Objective-C you declare a class's method like this:

```objc
- (void)readBackCover;
```

The minus sign at the beginning of the declaration means that the method is an `instance` method, which in turn means that it can only be called on instances of the `Book` class, and not the class itself.

The **void** means that the method has no return type. It doesn't return any value back to us when called.

This method doesn't have any arguments available to it, since books only have a single back cover and there's nothing more to it. Right?

Let's define another method that takes a arguments and returns a value.

```objc
- (BOOL)turnToPage:(int)pageNumber;
```

In this method, we first define a return type of `BOOL`, which is a boolean type definition Apple uses for truth values in it's own Objective-C-based frameworks.

We also define an argument of the `int` type, but before you say the argument's name is `pageNumber`, I'll explain a bit about the way methods work in Objective-C.

In Objective-C, methods don't have named arguments/parameters, but instead the method's name consists of the method's name and it's arguments. This gives what's called a *method selector* (more on this later) which defines the sentence-like structure or signature of the method.

In the above example, the name of our method would be `turnToPage:pageNumber`.

If you needed to support multiple parameters, you would just add it after the previous one as shown below.

```objc
- (BOOL)turnToPage:(int)pageNumber withForce:(int)force;
```

This is only for the sake of an example since we don't really need this argument in our method.

Your current `Book.h` file should now look like this:

```objc
#import <Foundation/Foundation.h>

@interface Book : NSObject

@property NSString *title;
@property NSString *authorName;
@property NSDate   *publishedDate;
@property NSNumber *pageCount;

- (void)readBackCover;
- (BOOL)turnToPage:(int)pageNumber;

@end
```

Next we'll see how to write the implementation for `Book`.

##### Basic Class Implementation

Once you're done defining the interface for your class in the `Book.h` file, you're ready to move into the implementation over in the `Book.m` file.

Implementing class functionality actually looks very similar to the interface file, so you'll have no trouble getting through this part.

The implementation for our Book class looks like this:

```objc
@implementation Book

- (void)readBackCover {
	// Code here...
}

- (BOOL)turnToPage:(int)pageNumber {
	if (pageNumber < 500)
		return YES;
	else
	return NO;
}

@end
```

There's not really anything new in this code example, apart from the `YES`, which is the `true` value in Objective-C. The **false** value is `NO`.

##### Initializing Classes

Typically when instantiating Objective-C classes, you would write code that looks like this:

```objc
Book *newBook = [[Book alloc] init];
```

What happens here is we're sending two messages, the `alloc` which is directly to the `Book` class, and the `init` on the return value of the first expression. Calling methods on objects in Objective-C is written with the following syntax:

```objc
[targetObject methodName:firstParameterValue];
```

So each method call is wrapped in square brackets and can be nested within eachother. Just like in our initialization example, we first call the `[Book alloc]` to allocate required memory for the Book class, which returns an instance of the allocated Book. With the return value of that expression, we then call the `init` method, which runs the object's initializer function that's used to set up properties in their default state.

##### Custom Initializers

Let's implement a custom initializer method for our class to set up properties into their initial state.

First we need to add the method declaration to our `Book.h` file:

```objc
- (id)initWithTitle:(NSString *)theTitle 
		 authorName:(NSString *)theAuthorName 
		  pageCount:(int)thePageCount;
```

Our initializer takes three parameters, and returns a type `id`. What's `id`? `id` is a pointer to any Objective-C object, and its value is defined during runtime. This is especially useful when you have methods that can return multiple types of values.

Next, open up your `Book.m` file and add the below code directly under the **@implementation** line.

```objc
- (id)initWithTitle:(NSString *)theTitle 
		 authorName:(NSString *)theAuthorName 
		  pageCount:(int)thePageCount {
	// Call our parent class's initializer method
	self = [super init];

	// Check if it succeeded
	if (self) {
		// Set up the property values
		_title      = theTitle;
		_authorName = theAuthorName;
		_pageCount  = thePageCount;
	}

	// Return our new instance
	return self;
}
```

In previous versions of the Objective-C runtime, you were required to write extra lines of code to create accessors to your properties. Nowadays Xcode creates these underscore (`_`) prefixed accessors behind the scenes for us, so we don't have to do it manually anymore.

Always (I atleast do) prefix with a `_` when accessing properties within the class implementation. This is not required when accessing properties from instances of the class.

Now that our initializer is done, we can change our previous instance creation code into this:

```objc
Book *newBook = [[Book alloc] initWithTitle:@"My Book Project" 
								 authorName:@"John Doe" 
								  pageCount:231]
```

Simple! After creating the `newBook` variable, we can now access the public methods and properties of it by.. you guessed it, doing this:

```objc
[newBook readBackCover];

NSString *myBooksTitle = newBook.title;
NSString *myAuthor     = newBook.authorName;
int       myPagecount  = newBook.pageCount;
```

I hope you have a basic understanding of how classes work in Objective-C now, and a grasp of the Objective-C syntax and how code is written and structured with it.

I will be continuing this series of articles another day with a bit more advanced Objective-C concepts.