//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigationProvider {
	
    internal typealias Scene = SnapNavigation.Scene<Destination>
    internal typealias Route = SnapNavigation.Route<Destination>
	
	internal func route(to destination: Destination) -> Route {
		let entries = entriesOnRoute(to: destination)
        return Route(entries: entries)
	}
	
	/// Get all entries of the route to a destination by traversing parents up to the root.
    private func entriesOnRoute(to destination: Destination) -> [Route.Entry] {
		guard let parent = parent(of: destination) else {
            return [Route.Entry(destination: destination, style: .select)]
		}
		
		var routeToParent = entriesOnRoute(to: parent)
        routeToParent.append(Route.Entry(destination: destination, style: destination.definition.presentationStyle))
		
		return routeToParent
	}
	
}
