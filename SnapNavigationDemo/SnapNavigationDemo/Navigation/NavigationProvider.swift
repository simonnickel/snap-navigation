//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

typealias Navigator = SnapNavigation.Navigator<NavigationProvider>

struct NavigationProvider: SnapNavigationProvider {
	
	typealias Destination = AppDestination
	
	func initial(for scene: SnapNavigation.NavigationScene<Destination>.Initializable) -> Destination {
		switch scene {
			case .main: .triangle
			case .settings: .settings
		}
	}
	
	var selectableDestinations: [Destination] { [.triangle, .rectangle, .circle] }
	
	func parent(of destination: Destination) -> Destination? {
		switch destination {
			case .triangle, .rectangle, .circle, .infinity, .settings, .feature(_): nil
			case .rectangleItem(let level):
				level > 1 ? .rectangleItem(level: level - 1) : .rectangle
			case .circleItem(let level):
				level > 1 ? .circleItem(level: level - 1) : .circle
		}
	}
	
}
