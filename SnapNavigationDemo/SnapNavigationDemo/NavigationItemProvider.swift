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
			case .circle: [.circle, .circleItem(level: 1), .circleItem(level: 2), .circleItem(level: 3)]
			default: []
		}
	}
	
	func location(of item: Item) -> SnapNavigation.State<Self>.Path? {
		// Top Level items an be accessed directly
		if items.contains(item) {
			return [item]
		}
		
		return switch item {
			case .circleItem(level: let level): [.triangle] + (1...level).map { .circleItem(level: $0) }
			default: nil
		}
	}
	
}
