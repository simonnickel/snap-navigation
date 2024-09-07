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
	private let entry: NavigationState.PresentationEntry?
	
	/// The additional `PresentationEntires` to stack on top.
	private let entries: [NavigationState.PresentationEntry]
	
	init(entries: [NavigationState.PresentationEntry]) {
		let first = entries.first
		self.entry = first
		self.entries = Array(entries.dropFirst())
	}
	
	func body(content: Content) -> some View {
		content
			.sheet(item: navigationState.presentationBinding(for: entry?.id)) { presentation in
				AnyView(presentation.screen.destination)
					.modifier(SnapPresentationModifier(entries: entries))
					.environment(navigationState)
			}
	}
	
}
