//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

struct NavigationItemProvider: SnapNavigationItemProvider {
	
	public typealias Path = [Item]
	
	static var initial: NavigationItem { .rectangle }
	
	var items: [Item] { [.triangle, .rectangle, .circle] }
	
	func subitems(for item: NavigationItem) -> [NavigationItem] {
		switch item {
			case .circle: [.circle, .circle1, .circle2, .circle3]
			default: []
		}
	}
	
	func path(for item: Item) -> SnapNavigation.State<Self>.Path {
		switch item {
			case .circle1: [.triangle]
			case .circle2: [.triangle, .circle1]
			case .circle3: [.triangle, .circle1, .circle2]
			default: []
		}
	}
	
}
