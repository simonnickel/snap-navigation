<!-- Copy badges from SPI -->
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-navigation%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/simonnickel/snap-navigation)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-navigation%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/simonnickel/snap-navigation) 

> This package is part of the [SNAP](https://github.com/simonnickel/snap) suite.


# SnapNavigation

Define the navigation structure of your SwiftUI app decoupled from it's presentation.

The package provides `SnapNavigationScreen` to define the structure of an app and `SnapNavigationView` presents it in different navigation approaches. 

[![Documentation][documentation badge]][documentation] 

[documentation]: https://swiftpackageindex.com/simonnickel/snap-navigation/main/documentation/snapnavigation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue


## Setup

Steps to setup the package ...

Setup GitHub page: Add Description and Topics, uncheck Packages and Deployments
Add to Swift Package Index
Update Badge and Documentation urls in README.md


## Demo project

The [demo project](/PackageDemo) shows ...

<img src="/screenshot.png" height="400">


## How to use

Details about package content ...


## Considerations

### TabSection
iOS 18 supports to group multiple Tabs into a TabSection: While the sidebar is visible, the Tabs are visible below the section header. While the TabBar is visible, only the section header is visible as a tab.

This causes ambiguous state when switching size classes or hiding the sidebar. I tried a few things, like manually adding the Section on the NavigationStack. But was not really happy with any of them.

Decision: Not supporting TabSection for now.

### .fullScreenCover()
Supporting a mix of .sheet() and .fullScreenCover() causes some animation issues in deeplink handling.

Decision: Not supporting .fullScreenCover() for now. Modal presentation uses .sheet().
