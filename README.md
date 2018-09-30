# PresentationKit
![](https://img.shields.io/badge/version-1.2-brightgreen.svg)

PresentationKit is a micro iOS Dynamic Framework with the single purpose of presenting `UIViewController`'s, from places within your code where you don't have reference to app's view controller hierarchy. A nice example of use case of this library is from within other libraries that need to present an authentication flow and dismiss it on completion. 

Build using Swift 4.1, Xcode 9.4.1, supports iOS 8.0+

# Usage

1. import module **PresentationKit** in the file you want to use the framework
2. On a `UIViewController` instance you now will be able to call `present(animated:, completion:)` and the view controller will be presented in a new `UIWindow` on top of all other `UIWindow`'s.
3. When you are done, call `dismiss(animated:, completion:)` on the presented `UIViewController` and the newly created `UIWindow` will be destroyed leaving the user interface in the intial state.

[`modalTransitionStyle`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621388-modaltransitionstyle) and [`modalPresentationStyle`](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621355-modalpresentationstyle) properties of `UIViewController`s are taken into account.

# Installation

### Carthage Installation

1. In your `Cartfile` add `github "stoqn4opm/PresentationKit"`
2. Link the build framework with the target in your XCode project

For detailed instructions check the official Carthage guides [here](https://github.com/Carthage/Carthage)

### Manual Installation

1. Download the project and build the shared target called `PresentationKit`
2. Add the product in the list of "embed frameworks" list inside your project's target or create a work space with PresentationKit and your project and link directly the product of PresentationKit's target to your target "embed frameworks" list

# Licence

The framework is licensed under MIT licence. For more information see file `LICENCE`
