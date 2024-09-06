//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public protocol SnapNavigationItemProvider {
	
	associatedtype Item: SnapNavigationItem
	
	var initial: Item { get }
	
	var items: [Item] { get }
	
	func route(to item: Item) -> [Item]?
	
	func subitems(for item: Item) -> [Item]
	
}
