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

The package provides `SnapNavigationDestination` to define Screens and `SnapNavigationProvider` to define how to navigate between them.

Use `SnapNavigationWindows` in your App definition to let SnapNavigation handle the presentation and window management. It provides a `Navigator` via Environment to trigger navigation actions. It supports different presentation styles like tabs or single page, which can be changed on the fly without losing the navigation state. 

Scene == Window
Destination == Screen


Supports:
 - iOS, iPadOS, macOS
 - iPadOS SplitView, resizing without loosing state
 - multiple windows on macOS and iPadOS
 - Deeplinking to Screens, Modals and Windows 
 - DynamicType
 
 // TODO: keyboard navigation, better accessibility support, sidebar reordering


## Demo project

The [demo project](/SnapNavigationDemo) shows a navigation hierarchy with 3 top level items to select. It allows infinite items to be pushed or presented as modals and a few deeplinks to navigate to a more complex state.

<img src="/screenshot.png" height="400">


## How to use

Define Destinations the App can navigate to:

```
enum Destination: SnapNavigationDestination {		
	case triangle, rectangle, circle
	
	var definition: SnapNavigation.ScreenDefinition<Self> {
		switch self {
			case .triangle: .init(title: "Triangle", systemIcon: "triangle")
			...
		}
	}
}
```

Implement a `SnapNavigationProvider` to define the structure of reachable destinations:

```
struct NavigationProvider: SnapNavigationProvider {
	var initialSelection: Destination { .triangle }
	
	var selectableDestinations: [Destination] { [.triangle, .rectangle, .circle] }
	
	func parent(of destination: Destination) -> Destination? {
		switch destination {
			case .triangle, .rectangle, .circle: nil
		}
	}
}
```

Use `SnapNavigationScene` as Scene in your App definition:
```
@main
struct SnapNavigationDemoApp: App {
	
    var body: some Scene {
		
		SnapNavigationScene(provider: NavigationProvider()) { scene, content in
			content
				.navigationStyle(.single)
				// ... setup more global stuff ... 
		}
		
    }
	
}```


## Considerations

### TabSection
iOS 18 supports to group multiple Tabs into a TabSection: While the sidebar is visible, the Tabs are visible below the section header. While the TabBar is visible, only the section header is visible as a tab.

This causes ambiguous state when switching size classes or hiding the sidebar. I tried a few things, like manually adding the Section on the NavigationStack. But was not really happy with any of them.

Decision: Not supporting TabSection for now.

### .fullScreenCover()
Supporting a mix of .sheet() and .fullScreenCover() causes some animation issues in deeplink handling.

Decision: Not supporting .fullScreenCover() for now. Modal presentation uses .sheet().

### macOS: TabView sidebarAdaptable clicking label does not select
Happening since macOS 15.1 [FB15680632](https://github.com/simonnickel/FB15680632-SwiftUImacOS-TabView-sidebarAdaptable-labelNotSelectable)
// TODO FB15680632: Check if issue is solved

### macOS: TabView with .sidebarAdaptable does not maintain state of Tab / Sidebar Item.
Decision: Did not find a way to maintain the navigation state, not worth it at the moment. Reconsider in the future.


// TODO: Define FullScreenCover as additional PresentationStyle, which can only be present once as last item with a path to show, no modals. (Or even with its own complete SnapNavigationView and State).

// TODO: Fix tapping in background when 2 modals are open closes all modals. (on iPad)
