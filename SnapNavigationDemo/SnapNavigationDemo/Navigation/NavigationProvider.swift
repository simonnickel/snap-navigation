//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

struct NavigationProvider: SnapNavigationProvider {
	
	typealias Destination = AppDestination
	
	func initial(for window: SnapNavigation.Window<Destination>.Initializable) -> Destination {
		switch window {
			case .main: .triangle
			case .settings: .settings
		}
	}
	
	func selectableDestinations(for window: SnapNavigation.Window<Destination>) -> [Destination] {
		switch window {
			case .main: [.triangle, .rectangle, .circle]
            case .window(_, let configuration):
            if configuration.style != .single, configuration.shouldBuildRoute {
					selectableDestinations(for: .main)
				} else {
					[]
				}
			case .settings: []
		}
	}
	
	func parent(of destination: Destination) -> Destination? {
		switch destination {
			case .triangle, .rectangle, .circle, .infinity, .settings, .feature(_): nil
			case .rectangleItem(let level):
				level > 1 ? .rectangleItem(level: level - 1) : .rectangle
			case .circleItem(let level):
				level > 1 ? .circleItem(level: level - 1) : .circle
		}
	}
	
	func translate(_ destination: any SnapNavigationDestination) -> AppDestination? {
		switch destination {
			case let destination as AppDestination: destination
			case let destination as FeatureDestination: .feature(destination)
			default: nil
		}
	}
	
}
