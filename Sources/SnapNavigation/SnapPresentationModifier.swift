//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

/// A recursive modifier that modally presents a stack of `PresentationEntries`.
struct SnapPresentationModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
	/// The `PresentationEntry` to present.
	private let entry: NavigationState.RouteEntry?
	
	/// The additional `PresentationEntires` to stack on top.
	private let entries: [NavigationState.RouteEntry]
	
	init(entries: [NavigationState.RouteEntry]) {
		let first = entries.first
		self.entry = first
		self.entries = Array(entries.dropFirst())
	}
	
	func body(content: Content) -> some View {
		content
			.sheet(item: navigationState.sheetBinding(for: entry?.id)) { routeEntry in
				Group {
					if let root = routeEntry.screens.first {
						// TODO: SnapNavigationStack schould just get a RouteEntry
						SnapNavigationStack(path: navigationState.pathBinding(for: root), root: root)
					} else {
						EmptyView()
					}
				}
				.modifier(SnapPresentationModifier(entries: entries))
				.environment(navigationState)
			}
	}
	
}
