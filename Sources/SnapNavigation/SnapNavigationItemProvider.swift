//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public protocol SnapNavigationItemProvider {
	
	associatedtype Item: SnapNavigationItem
	
	static var initial: Item { get }
	
	var items: [Item] { get }
	
	func path(for item: Item) -> [Item]
	
	func subitems(for item: Item) -> [Item]
	
}
