//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

typealias NavigationState = SnapNavigation.State<NavigationProvider>

struct NavigationProvider: SnapNavigationProvider {
	
	public typealias Path = [Screen]
	var initialSelection: Screen { .triangle }
	
	var selectableScreens: [Screen] { [.triangle, .rectangle, .circle] }
	
	func parent(of screen: Screen) -> Screen? {
		switch screen {
			case .triangle, .rectangle, .circle, .infinity: nil
			case .rectangleItem(let level):
				level > 1 ? .rectangleItem(level: level - 1) : .rectangle
			case .circleItem(let level):
				level > 1 ? .circleItem(level: level - 1) : .circle
		}
	}
	
}
