# AGHeadsUpView

AGHeadsUpView is an iOS library used to render text or a loading indicator in an unobtrusive HUD. Architected with multiple screen sizes and orientations in mind, AGHeadsUpView relies on Autolayout for drawing and animation. In addition, the background of each HUD uses Apple's UIBlurEffect for layered spacial contexts.

## Getting Started

- [Download AGHeadsUpView](https://github.com/alexgivens/AGHeadsUpView/archive/master.zip) and try the included example project.
- Copy the "AGHeadsUpView" directory into your project
- Import the header file at the top of your document, like so: ```#import "AGHeadsUpView.h"```

## Using AGHeadsUpView

AGHeadsUpView can show a HUD for a definite time. These methods are best for notifications of a singular action.

```objective-c
[AGHeadsUpView showLoadingViewWithDefiniteTime:2.0];
[AGHeadsUpView showText:@"Hello World" withDefiniteTime:2.0];
```

AGHeadsUpView can also show a HUD indefintely, to be manually dismissed later on. These methods are best for representing asynchronous network requests and other indeterminate tasks.

```objective-c
[AGHeadsUpView showLoadingView];
// Perform an asynchronous network task.
[AGHeadsUpView dismiss];
```

## Requirements

AGHeadsUpView is supported on iOS 8.0+ and requires ARC. 

## Credits

AGHeadsUpView was originally designed and developed by [Alex Givens](http://alexgivens.com) for the [Color Myx](https://itunes.apple.com/us/app/color-myx/id937256071?mt=8) music player. The spinning loading indicator for AGHeadsUpView is provided by [LLARingSpinnerView by Lukas Lipka](https://github.com/lipka/LLARingSpinnerView). Both AGHeadsUpView and LLARingSpinnerView reside under the [MIT License](https://github.com/AlexGivens/AGHeadsUpView/blob/master/LICENSE).


