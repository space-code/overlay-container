<h1 align="center" style="margin-top: 0px;">overlay-container</h1>

<p align="center">
<a href="https://github.com/space-code/overlay-container/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/overlay-container?style=flat"></a> 
<a href="https://swiftpackageindex.com/space-code/overlay-container"><img alt="Swift Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Foverlay-container%2Fbadge%3Ftype%3Dswift-versions"/></a> 
<a href="https://swiftpackageindex.com/space-code/overlay-container"><img alt="Platform Compatibility" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fspace-code%2Foverlay-container%2Fbadge%3Ftype%3Dplatforms"/></a> 
<a href="https://github.com/space-code/overlay-container"><img alt="CI" src="https://github.com/space-code/overlay-container/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/space-code/overlay-container"><img alt="GitHub release; latest by date" src="https://img.shields.io/github/v/release/space-code/overlay-container"></a>
<a href="https://github.com/apple/swift-package-manager" alt="overlay-container on Swift Package Manager" title="overlay-container on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>

## Description
`overlay-container` is a lightweight Swift library for managing overlays and bottom sheets in iOS applications. It provides a flexible and customizable way to present draggable, resizable, and interactive overlays, making it easy to implement bottom sheets, modals, and other layered UI components.

- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Usage

```swift
import OverlayContainer

func presentSheet(_ viewController: UIViewController) {
    let sheetViewController = OverlayContainer(
        contentContainer: viewController,
        configuration: .init(
            cornerRadius: 16,
            insets: .zero,
            grabberType: .hidden
        )
    )
    present(sheetViewController, animated: true)
}
```

## Requirements

- iOS 12.0+
- Xcode 16.0
- Swift 5.7

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `overlay-container` does support its use on supported platforms.

Once you have your Swift package set up, adding `overlay-container` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/space-code/overlay-container.git", .upToNextMajor(from: "1.0.0"))
]
```

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Contributing
Bootstrapping development environment

```
make bootstrap
```

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request!

## Author
Nikita Vasilev, nv3212@gmail.com

## License
overlay-container is available under the MIT license. See the LICENSE file for more info.
