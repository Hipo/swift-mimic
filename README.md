<p align="center"><img src="https://github.com/Hipo/swift-mimic/blob/master/mimic-banner.png"></p>

[![Version](https://img.shields.io/cocoapods/v/swift-mimic.svg?style=flat)](http://cocoapods.org/pods/swift-mimic)
[![License](https://img.shields.io/cocoapods/l/swift-mimic.svg?style=flat)](http://cocoapods.org/pods/swift-mimic)
[![Platform](https://img.shields.io/cocoapods/p/swift-mimic.svg?style=flat)](http://cocoapods.org/pods/swift-mimic)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://swift.org/)

## Overview

`Swift-Mimic` is a library for **mocking network requests** with minimal code changes. It can be used for:

* Converting unit tests and UI tests to run on mocked API responses, minimizing test maintenance and optimizing tests for speed
* Developing new features before actual API endpoints are ready, with minimal code changes

`Swift-Mimic` is designed to be a batteries included, easy-to-integrate solution with several extensible features:

* File-based mock bundles that reflect the API endpoint structures, coupled with a base URL
* Support for multiple mock bundle suites, cascading with overrides for different test scenarios
* Swappable mock bundle protocol so you can develop your own advanced bundle formats if needed
* Automated endpoint discovery from mock bundles, so default scenarios require no code
* Integration with any existing unit or UI test using three lines of code

## Installation

We recommend using Cocoapods for installing:

```
pod 'swift-mimic'
```

**IMPORTANT:** Due to a [known Cocoapods issue](https://github.com/CocoaPods/CocoaPods/issues/8139), UI tests might fail to compile. Documented solution for now is to include the following `post_install` hook in your `Podfile`:

```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # This works around a unit test issue introduced in Xcode 10.
            # We only apply it to the Debug configuration to avoid bloating the app size
            if config.name == "Debug" && defined?(target.product_type) && target.product_type == "com.apple.product-type.framework"
                config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = "YES"
            end
        end
    end
end
```

## Configuration

### Creating Mock Bundles

First step before configuring your application to use `Swift-Mimic` is to create an API mock bundle. There are several ways of doing this, from manually generating the folder and file structure to using a recorder framework such as [SWHttpTrafficRecorder](https://github.com/capitalone/SWHttpTrafficRecorder).

Structure of the mock bundle is simple. Let's assume that you have an API that provides the following endpoints:

* https://my-service.com/api/authenticate/
* https://my-service.com/api/users/
* https://my-service.com/api/projects/

And let's assume that you will be mocking the following requests:

* POST https://my-service.com/api/authenticate/
* GET https://my-service.com/api/users/
* GET https://my-service.com/api/projects/
* POST https://my-service.com/api/projects/

Your mock bundle structure should then look like this:

* Mocks.bundle
  * api
    * authenticate
      * post.json
    * users
      * get.json
    * projects
      * get_200.json
      * post_201.json

Every JSON file in this list should contain the API response that should be mocked. File names can be provided in two formats: `HTTP METHOD.json` or `HTTP METHOD_RESPONSE CODE.json`. If you don't provide a response code, `Swift-Mock` will assume that the matching HTTP method is the default file and will prioritize that over others.

You may add the bundle anywhere in your Xcode project, however make sure that it's linked against both your main application target, as well as your test target.

You may create as many bundles as you like, to either organize endpoints under a single base URL or support mocks under multiple API URLs.

### Updating Network Integration

For `Swift-Mimic` to override network requests without additional code, you need to pass a special configuration to the active `URLSession` your API requests layer uses. This is very easy to do, here is an example that uses `Alamofire`:

```
if let mockUrlSessionConfiguration = MimicSession.shared?.urlSessionConfiguration {
  sessionManager = Alamofire.SessionManager(configuration: mockUrlSessionConfiguration)
} else {
  sessionManager =  SessionManager.default
}
```

This is a standard `URLSessionConfiguration` object, so it can be passed to any network layer that runs on `URLSession`, including Apple's vanilla implementation.

### Setting Up Test Suites

Final step is to define your mock suites in your testing layer so the test runner is launched aware of the mocks it is configured with. Here is the simplest implementation you can do:

```
import XCTest
import swift_mimic


extension XCUIApplication: MimicUIApplication {
    
}


class ExampleTest: XCTestCase {

    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false

        let suite = MIMMockSuite(baseURL: "https://my-service.com", mockBundleName: "Mocks")

        try? MimicLauncher.launch(app, with: [suite])
    }

}
```

There are a few things happening here. First off, we make sure that the `XCUIApplication` is setup to include `MimicUIApplication`. You need to do this only once somewhere in your test target.

Then we create a `MIMMockSuite` instance that points to the correct bundle in the project and pairs it with the API base URL we would like to override.

Finally, we call `MimicLauncher` with the suite we just created, so it can include it in the configuration.

You can create as many suites as you like, and pass them to the launcher in the order you would like them to be loaded in. Let's say you have a specific authentication case for a test suite, you could do the following to take advantage of the cascading nature of suites:

```
class ExampleTest: XCTestCase {

    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        let suite = MIMMockSuite(baseURL: "https://my-service.com", mockBundleName: "Mocks")
        let adminSuite = MIMMockSuite(baseURL: "https://my-service.com", mockBundleName: "AdminMocks")

        try? MimicLauncher.launch(app, with: [suite, adminSuite])
    }

}
```

## Release History

* 0.2.5 - Jan 14, 2019
    * Add documentation
* 0.2.3 - Jan 13, 2019
    * First stable release with complete sample project

## Credits

Built by the [Hipo](https://hipolabs.com) team, with contributions by:

* Goktug Berk Ulu
* Eray Diler
* Salih Karasuluoglu
* Taylan Pince

## Contributing

1. Fork it (<https://github.com/Hipo/swift-mimic/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## License

Distributed under the MIT license. See ``LICENSE`` for more information.
