<!-- Copy badges from SPI -->
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-navigation%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/simonnickel/snap-navigation)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsimonnickel%2Fsnap-navigation%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/simonnickel/snap-navigation)

> This package is part of the [SNAP](https://github.com/simonnickel/snap) suite.


# SnapNavigation

Define the navigation structure of your SwiftUI app decoupled from it's presentation.

[![Documentation][documentation badge]][documentation] 

[documentation]: https://swiftpackageindex.com/simonnickel/snap-navigation/main/documentation/snapnavigation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue

SnapNavigation allows you to define the navigation hierarchy of your app in a generic way. Screens can be displayed by selection, pushes (on selected or current modal stack) or modal presentation. It also allows to deeplink to a specific Screen with the whole hierarchy being setup. 

The package provides `SnapNavigationScreen` to setup Screens and `SnapNavigationProvider` to define how to navigate between them.

The presentation is independent and could easily be replaced by a different style. The `SnapNavigationView` shows the Screens in a SwiftUI TabView with sidebar when suitable. It manages the `Navigator`, which can be used to trigger navigation actions.

Supports:
 - iOS, iPadOS, macOS
 - iPadOS SplitView, resizing without loosing state
 - DynamicType
 
 // TODO: keyboard navigation, better accessibility support, multi window, sidebar reordering


## Demo project

The [demo project](/SnapNavigationDemo) shows a navigation hierarchy with 3 top level items to select. It allows infinite items to be pushed or presented as modals and a few deeplinks to navigate to a more complex state.

<img src="/screenshot.png" height="400">


## How to use

Define Screens the App can navigate to:

```
enum Screen: SnapNavigationScreen {		
	case triangle, rectangle, circle
	
	var definition: SnapNavigation.ScreenDefinition<Self> {
		switch self {
			case .triangle: .init(title: "Triangle", systemIcon: "triangle")
			...
		}
	}
}
```

Implement a `SnapNavigationProvider` to define the structure of reachable screens:

```
struct NavigationProvider: SnapNavigationProvider {
	var initialSelection: Screen { .triangle }
	
	var selectableScreens: [Screen] { [.triangle, .rectangle, .circle] }
	
	func parent(of screen: Screen) -> Screen? {
		switch screen {
			case .triangle, .rectangle, .circle: nil
		}
	}
}
```

Use the `SnapNavigationView`:
```
SnapNavigationView(
	provider: NavigationProvider()
)
.tabViewSidebarHeader {
	...
}
.tabViewSidebarFooter {
	...
}
```


## Considerations

### TabSection
iOS 18 supports to group multiple Tabs into a TabSection: While the sidebar is visible, the Tabs are visible below the section header. While the TabBar is visible, only the section header is visible as a tab.

This causes ambiguous state when switching size classes or hiding the sidebar. I tried a few things, like manually adding the Section on the NavigationStack. But was not really happy with any of them.

Decision: Not supporting TabSection for now.

### .fullScreenCover()
Supporting a mix of .sheet() and .fullScreenCover() causes some animation issues in deeplink handling.

Decision: Not supporting .fullScreenCover() for now. Modal presentation uses .sheet().

// TODO: Define FullScreenCover as additional PresentationStyle, which can only be present once as last item with a path to show, no modals. (Or even with its own complete SnapNavigationView and State).

// TODO: Fix tapping in background when 2 modals are open closes all modals. (on iPad)
