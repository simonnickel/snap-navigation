//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigationProvider {
	
	internal typealias RouteEntry = SnapNavigation.RouteEntry
	internal typealias Route = [RouteEntry<Screen>]
	
	internal func route(to screen: Screen) -> Route {
		let route = routeEntries(to: screen)
		return route.condense()
	}
	
	/// Get all entries of the route to a screen by traversing parents up to the root.
	private func routeEntries(to screen: Screen) -> Route {
		guard let parent = parent(of: screen) else {
			return [RouteEntry(root: screen, path: [], style: .select)]
		}
		
		var routeToParent = routeEntries(to: parent) ?? []
		routeToParent.append(RouteEntry(root: screen, path: [], style: screen.definition.presentationStyle))
		
		return routeToParent
	}
	
}
