//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

struct NavigationProvider: SnapNavigationProvider {
	
	public typealias Path = [Screen]
	
	var initial: Screen { .triangle }
	
	var screens: [Screen] { [.triangle, .rectangle, .circle, .circleSection] }
	
	func subscreens(for screen: Screen) -> [Screen] {
		switch screen {
			case .circleSection: [.circleSection, .circleItem(level: 1), .circleItem(level: 2), .circleItem(level: 3)]
			default: []
		}
	}
	
	func route(to screen: Screen) -> SnapNavigation.State<Self>.Path? {
		// Top Level screens can be accessed directly
		if screens.contains(screen) {
			return [screen]
		}
		
		return switch screen {
			case .circleItem(level: let level): [.circle] + (1...level).map { .circleItem(level: $0) }
				
			case .rectangleItem(level: let level): [.rectangle] + (1...level).map { .rectangleItem(level: $0) }
				
			default: nil
		}
	}
	
}
