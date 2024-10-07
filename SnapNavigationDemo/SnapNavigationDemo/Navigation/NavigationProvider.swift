//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

typealias NavigationState = SnapNavigation.State<NavigationProvider>

struct NavigationProvider: SnapNavigationProvider {
	
	public typealias Path = [Screen]
	
	var initial: Screen { .triangle }
	
	var screens: [Screen] { [.triangle, .rectangle, .circle, .circleSection] }
	
	func parent(of screen: Screen) -> Screen? {
		switch screen {
			case .triangle, .rectangle, .circle, .circleSection, .infinity: nil
			case .rectangleItem(let level):
				level > 1 ? .rectangleItem(level: level - 1) : .rectangle
			case .circleItem(let level):
				level > 1 ? .circleItem(level: level - 1) : .circle
		}
	}
		
	func subscreens(for screen: Screen) -> [Screen] {
		switch screen {
			case .circleSection: [.circleSection, .circleItem(level: 1), .circleItem(level: 2), .circleItem(level: 3)]
			default: []
		}
	}
	
}
