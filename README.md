# Adobe Experience Platform Consent Collection Mobile Extension

[![CocoaPods](https://img.shields.io/github/v/release/adobe/aepsdk-edgeconsent-ios?label=CocoaPods&logo=apple&logoColor=white&color=orange)](https://cocoapods.org/pods/AEPEdgeConsent) 
[![SPM](https://img.shields.io/github/v/release/adobe/aepsdk-edgeconsent-ios?label=SPM&logo=apple&logoColor=white&color=orange)](https://github.com/adobe/aepsdk-edgeconsent-ios/releases) 
[![CircleCI](https://img.shields.io/circleci/project/github/adobe/aepsdk-edgeconsent-ios/main.svg?logo=circleci&label=Build)](https://circleci.com/gh/adobe/workflows/aepsdk-edgeconsent-ios) 
[![Code Coverage](https://img.shields.io/codecov/c/github/adobe/aepsdk-edgeconsent-ios/main.svg?logo=codecov&label=Coverage)](https://codecov.io/gh/adobe/aepsdk-edgeconsent-ios/branch/main)

## About this project

The AEP Consent Collection mobile extension enables consent preferences collection from the mobile application when using the [Adobe Experience Platform SDK](https://developer.adobe.com/client-sdks) and the Edge Network extension.

## Requirements
- Xcode 14.1 (or newer)
- Swift 5.1 (or newer)

## Installation

These are currently the supported installation options:

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

# for app development, include all the following pods
target 'YOUR_TARGET_NAME' do
    pod 'AEPEdgeConsent'
    pod 'AEPCore'
    pod 'AEPEdge'
    pod 'AEPEdgeIdentity'
end

# for extension development, include AEPCore, AEPEdgeConsent, and their dependencies
target 'YOUR_TARGET_NAME' do
    pod 'AEPEdgeConsent'
    pod 'AEPCore'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```ruby
$ pod install
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

To add the AEPEdgeConsent Package to your application, from the Xcode menu select:

`File > Add Packages...`

> **Note** 
>  The menu options may vary depending on the version of Xcode being used.

Enter the URL for the AEPEdgeConsent package repository: `https://github.com/adobe/aepsdk-edgeconsent-ios.git`.

When prompted, make sure you change the branch to `main`. (Once the repo is public, we will reference specific tags/versions instead of a branch)

Alternatively, if your project has a `Package.swift` file, you can add AEPEdgeConsent directly to your dependencies:

```
dependencies: [
    .package(url: "https://github.com/adobe/aepsdk-edgeconsent-ios.git", .upToNextMajor(from: "4.0.0"))
],
targets: [
    .target(name: "YourTarget",
            dependencies: ["AEPEdgeConsent"],
            path: "your/path")    
]
```

### Binaries

To generate an `AEPEdgeConsent.xcframework`, run the following command:

```ruby
$ make archive
```

This generates the xcframework under the `build` folder. Drag and drop all the `.xcframeworks` to your app target in Xcode.

## Development

The first time you clone or download the project, you should run the following from the root directory to setup the environment:

~~~
make pod-install
~~~

Subsequently, you can make sure your environment is updated by running the following:

~~~
make pod-update
~~~

#### Open the Xcode workspace
Open the workspace in Xcode by running the following command from the root directory of the repository:

~~~
make open
~~~

#### Command line integration

You can run all the test suites from command line:

~~~
make test
~~~

## Related Projects

| Project                                                      | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [AEPCore Extensions](https://github.com/adobe/aepsdk-core-ios) | The AEPCore and AEPServices represent the foundation of the Adobe Experience Platform SDK. |
| [AEPEdge Extension](https://github.com/adobe/aepsdk-edge-ios) | The AEPEdge extension allows you to send data to the Adobe Experience Platform (AEP) from a mobile application. |
| [AEPEdgeIdentity Extension](https://github.com/adobe/aepsdk-edgeidentity-ios) | The AEPEdgeIdentity enables handling of user identity data from a mobile app when using the AEPEdge extension. |
| [AEP SDK Sample App for iOS](https://github.com/adobe/aepsdk-sample-app-ios) | Contains iOS sample apps for the AEP SDK. Apps are provided for both Objective-C and Swift implementations. |
| [AEP SDK Sample App for Android](https://github.com/adobe/aepsdk-sample-app-android) | Contains Android sample app for the AEP SDK.                 |
## Contributing

Contributions are welcomed! Read the [Contributing Guide](./.github/CONTRIBUTING.md) for more information.

## Licensing

This project is licensed under the Apache V2 License. See [LICENSE](LICENSE) for more information.
