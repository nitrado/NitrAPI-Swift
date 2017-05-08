# nitrapi

[![Version](https://img.shields.io/cocoapods/v/nitrapi.svg?style=flat)](http://cocoapods.org/pods/nitrapi)
[![License](https://img.shields.io/cocoapods/l/nitrapi.svg?style=flat)](http://cocoapods.org/pods/nitrapi)
[![Platform](https://img.shields.io/cocoapods/p/nitrapi.svg?style=flat)](http://cocoapods.org/pods/nitrapi)

## Installation

nitrapi is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "nitrapi"
```

## Example
``` swift
    let nitrapi = Nitrapi(accessToken: "<access token>")
    do {
         let services = nitrapi.getServices()
        // ...
    } catch {
        // An error occured
    }
´´´

## License

nitrapi is available under the MIT license. See the LICENSE file for more info.
