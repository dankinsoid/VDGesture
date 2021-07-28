# VDGesture

[![CI Status](https://img.shields.io/travis/dankinsoid/VDGesture.svg?style=flat)](https://travis-ci.org/dankinsoid/VD)
[![Version](https://img.shields.io/cocoapods/v/VDGesture.svg?style=flat)](https://cocoapods.org/pods/VD)
[![License](https://img.shields.io/cocoapods/l/VDGesture.svg?style=flat)](https://cocoapods.org/pods/VD)
[![Platform](https://img.shields.io/cocoapods/p/VDGesture.svg?style=flat)](https://cocoapods.org/pods/VD)

## Description
This repository contains new way to work with gestures

## Usage
## Installation
1.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'VDGesture'
```
and run `pod update` from the podfile directory first.

2. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/VDGesture.git", from: "0.3.0")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["VDGesture"])
  ]
)
```
```ruby
$ swift build
```

## Author

dankinsoid, voidilov@gmail.com

## License

VDGesture is available under the MIT license. See the LICENSE file for more info.
