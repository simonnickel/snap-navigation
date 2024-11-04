//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

extension SnapNavigation.Navigator {
	
	internal struct State: Sendable {
		
		internal typealias Route = [SnapNavigation.RouteEntry<Destination>]
		internal typealias Destination = NavigationProvider.Destination
		
		internal var selected: Destination
		internal var pathForSelection: [Destination : Path] = [:]
		
		internal var modals: [SnapNavigation.RouteEntry<Destination>] = []
		
		internal init(selected: Destination) {
			self.selected = selected
		}
		
		internal init(route: Route) {
			guard let selected = route.first?.root else {
				fatalError("A Route should always have at least one item!")
			}
			
			self.init(selected: selected)
			
			update(route)
		}
		
		
		// MARK: - Update
		
		mutating internal func update(_ route: Route) {
			var route = route
			
			// Select
			guard let firstEntry = route.first, firstEntry.style == .select else {
				fatalError("First item of a Route should be of style `.select`!")
			}
			
			selected = firstEntry.root
			route.removeFirst()
			
			// Push
			if let entry = route.first, entry.style == .push {
				update([entry.root] + entry.path, for: .selection(destination: selected))
			} else {
				update([], for: .selection(destination: selected))
			}
			
			// Modals
			modals = []
			for entry in route.filter({ $0.style == .modal }) {
				modals.append(entry)
			}
		}
		
		mutating internal func update(_ path: Path, for context: PathContext) {
			switch context {
				case .selection(let destination):
					pathForSelection[destination] = path
					
				case .modal(let level):
					if modals.count > level {
						var entry = modals[level]
						entry.path = path
						modals[level] = entry
					}
			}
		}
		
	}
	
}
