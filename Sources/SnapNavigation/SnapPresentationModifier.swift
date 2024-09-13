//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

/// A recursive modifier that modally presents a stack of `PresentationEntries`.
struct SnapPresentationModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
	private let level: Int
	
	init(level: Int) {
		self.level = level
	}
	
	func body(content: Content) -> some View {
		let level = navigationState.sheetLevelInverted(self.level)
		if level >= 0 {
			content
				.sheet(isPresented: navigationState.sheetBinding(for: level)) {
					SnapNavigationStack<NavigationProvider>(context: .sheet(level: level))
						.modifier(SnapPresentationModifier(level: self.level - 1))
						.environment(navigationState)
				}
		} else {
			content
		}
	}
	
}
