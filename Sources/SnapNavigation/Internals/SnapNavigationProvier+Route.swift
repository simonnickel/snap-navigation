//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigationProvider {
	
	internal typealias RouteEntry = SnapNavigation.RouteEntry
	internal typealias Route = [RouteEntry<Destination>]
	
	internal func route(to destination: Destination) -> Route {
		let route = routeEntries(to: destination)
		return route.condense()
	}
	
	/// Get all entries of the route to a destination by traversing parents up to the root.
	private func routeEntries(to destination: Destination) -> Route {
		guard let parent = parent(of: destination) else {
			return [RouteEntry(root: destination, path: [], style: .select)]
		}
		
		var routeToParent = routeEntries(to: parent)
		routeToParent.append(RouteEntry(root: destination, path: [], style: destination.definition.presentationStyle))
		
		return routeToParent
	}
	
}
