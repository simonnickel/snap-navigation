//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

/// A recursive modifier that modally presents a stack of `PresentationEntries`.
struct SnapPresentationModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
	private let levelIteration: Int
	
	init(level: Int) {
		self.levelIteration = level
	}
	
	func body(content: Content) -> some View {
		// SnapPresentationModifier has to start with highest visible level to recursively present sheets.
		// Therefore it has to invert the level to get the correct bindings.
		let level = navigationState.sheetLevelInverted(levelIteration)
		
		if level >= SnapNavigation.Constants.sheetLevelMin {
			content
				.sheet(isPresented: navigationState.sheetBinding(for: level)) {
					SnapNavigationStack<NavigationProvider>(context: .sheet(level: level))
						.modifier(SnapPresentationModifier(level: levelIteration - 1))
						.environment(navigationState)
				}
		} else {
			content
		}
	}
	
}
