//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

/// A recursive modifier that modally presents a stack of `PresentationEntries`.
struct SnapNavigationModalModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
	private let levelIteration: Int
	
	init(level: Int) {
		self.levelIteration = level
	}
	
	func body(content: Content) -> some View {
		// SnapNavigationModalModifier has to start with highest visible level to recursively present modals.
		// Therefore it has to invert the level to get the correct bindings.
		let level = navigationState.modalLevelInverted(levelIteration)
		
		if level >= SnapNavigation.Constants.modalLevelMin {
			content
				.sheet(isPresented: navigationState.modalBinding(for: level)) {
					SnapNavigationStack<NavigationProvider>(context: .modal(level: level))
						.modifier(SnapNavigationModalModifier(level: levelIteration - 1))
						.environment(navigationState)
				}
		} else {
			content
		}
	}
	
}
