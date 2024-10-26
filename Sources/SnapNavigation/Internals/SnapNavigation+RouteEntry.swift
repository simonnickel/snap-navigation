//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

internal extension SnapNavigation {
	
	struct RouteEntry<Screen: SnapNavigationScreen>: Equatable, Identifiable, Hashable, Sendable {
		
		internal typealias Path = [Screen]
		
		var id: Int { hashValue }
		var root: Screen
		var path: Path
		let style: PresentationStyle
	}
	
}

internal extension Array {
	
	/// Join an Array of `RouteEntry` based on their `PresentationStyle` into one or multiple`RouteEntry` with elements on their path.
	func condense<Screen>() -> Self where Element == SnapNavigation.RouteEntry<Screen> {
		var route = self
		var result: Self = []
		guard let first = route.first else { return result }
		
		var currentEntry: Self.Element = first
		route.removeFirst()
		
		for entry in route {
			if entry.style == .push && currentEntry.style != .select {
				currentEntry.path = currentEntry.path + [entry.root] + entry.path
			} else {
				result.append(currentEntry)
				currentEntry = entry
			}
		}
		result.append(currentEntry)
		
		return result
	}
	
}
