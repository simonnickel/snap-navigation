//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation

struct NavigationItemProvider: SnapNavigationItemProvider {
	
	public typealias Path = [Item]
	
	var initial: NavigationItem { .rectangle }
	
	var items: [Item] { [.triangle, .rectangle, .circle, .circleSection] }
	
	func subitems(for item: NavigationItem) -> [NavigationItem] {
		switch item {
			case .circleSection: [.circleSection, .circleItem(level: 1), .circleItem(level: 2), .circleItem(level: 3)]
			default: []
		}
	}
	
	func route(to item: Item) -> SnapNavigation.State<Self>.Path? {
		// Top Level items can be accessed directly
		if items.contains(item) {
			return [item]
		}
		
		return switch item {
			case .circleItem(level: let level): [.circle] + (1...level).map { .circleItem(level: $0) }
				
			case .rectangleItem(level: let level): [.rectangle] + (1...level).map { .rectangleItem(level: $0) }
				
			default: nil
		}
	}
	
}
