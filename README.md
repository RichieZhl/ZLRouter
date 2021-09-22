# ZLRouter

[![CI Status](https://img.shields.io/travis/richiezhl/ZLRouter.svg?style=flat)](https://travis-ci.org/richiezhl/ZLRouter)
[![Version](https://img.shields.io/cocoapods/v/ZLRouter.svg?style=flat)](https://cocoapods.org/pods/ZLRouter)
[![License](https://img.shields.io/cocoapods/l/ZLRouter.svg?style=flat)](https://cocoapods.org/pods/ZLRouter)
[![Platform](https://img.shields.io/cocoapods/p/ZLRouter.svg?style=flat)](https://cocoapods.org/pods/ZLRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZLRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'ZLRouter'

[ZLRouter registerURLPattern:@"afff://fjfj/:id/fasdf/:ai" toHandler:^(NSDictionary *routerParameters) {
    NSLog(@"%@", routerParameters);
    void (^block)(id result) = (void (^)(id result))routerParameters[ZLJRouterParameterCompletion];
    block(@22);
}];

[ZLRouter openURL:@"afff://fjfj/23/fasdf/asdkf?a=b" withUserInfo:@"fff" completion:^(id result) {
    NSLog(@"%@", result);
}];
```

## Author

richiezhl, lylaut@163.com

## License

ZLRouter is available under the MIT license. See the LICENSE file for more info.
