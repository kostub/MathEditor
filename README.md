# MathEditor

[![CI Status](http://img.shields.io/travis/kostub/MathEditor.svg?style=flat)](https://travis-ci.org/kostub/MathEditor)
[![Version](https://img.shields.io/cocoapods/v/MathEditor.svg?style=flat)](http://cocoapods.org/pods/MathEditor)
[![License](https://img.shields.io/cocoapods/l/MathEditor.svg?style=flat)](http://cocoapods.org/pods/MathEditor)
[![Platform](https://img.shields.io/cocoapods/p/MathEditor.svg?style=flat)](http://cocoapods.org/pods/MathEditor)

MathEditor is a WYSIWYG editor for math formulas on iOS. It provides a
UIView which edits math while it is being rendered. For rendering math
it uses the [iosMath](http://github.com/kostub/iosMath) library to get
LaTeX style typesetting.

A math keyboard is included with the editor. However you can supply your
own keyboard or use the system default keyboard as well. The math
keyboard is optimized to easily enter certain components like fractions,
exponents and square roots.

## Example

There is a sample app included in this project that shows how to use the
math editor as well as code for automatically resizing the editor as the
text in it changes. To run the same app, clone the repository, and run
`pod install` from the `Example` directory first. Then run the
__MathEditor_Example__ app.

## Requirements
`MathEditor` works on iOS 8+ and requires ARC to build. It depends on
the following Cocoapod:

* [iosMath](http://cocoapods.org/pods/iosMath)

Additionaly, it depends on the following Apple frameworks:

* Foundation.framework
* UIKit.framework

## Installation

`MathEditor` is available through [CocoaPods](http://cocoapods.org). To
install it, simply add the following line to your Podfile:

```ruby
pod "MathEditor"
```
## Usage

The library provides a class `MTEditableMathLabel` which is a `UIView` that
supports editing math equations. Simply add it to your storyboard or
create it programmatically.

```objective-c
#import "MTEditableMathLabel.h"

MTEditableMathLabel* label = [[MTEditableMathLabel alloc] initWithFrame:...]
label.delegate = self;

```

### Keyboard

To use the provided keyboard, set:

```objective-c
label.keyboard = [MTMathKeyboardRootView sharedInstance];
```

You can set any keyboard you want to use. A keyboard needs to be a
`UIView` and implement the `MTMathKeyboard` interface.

To use the default system keyboard, set `keyboard = nil`. (This is the
default.)

## License

MathEditor is available under the MIT license. See the
[LICENSE](./LICENSE) file for more info.

