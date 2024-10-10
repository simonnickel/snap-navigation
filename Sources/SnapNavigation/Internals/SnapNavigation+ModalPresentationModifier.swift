//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
	
	/// A modifier to present multiple modals by recursively applying itself for each level of presentation visible.
	internal struct ModalPresentationModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
		
		typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
		@Environment(Navigator.self) private var navigator
		
		private let levelIteration: Int
		
		init(level: Int) {
			self.levelIteration = level
		}
		
		func body(content: Content) -> some View {
			// ModalPresentationModifier has to start with highest visible level to recursively present modals.
			// Therefore it has to invert the level to get the correct bindings.
			let level = navigator.modalLevelInverted(levelIteration)
			
			if level >= SnapNavigation.Constants.modalLevelMin {
				content
					.sheet(isPresented: navigator.modalBinding(for: level)) {
						SnapNavigationStack<NavigationProvider>(context: .modal(level: level))
							.modifier(ModalPresentationModifier(level: levelIteration - 1))
							.environment(navigator)
					}
			} else {
				content
			}
		}
		
	}
	
}
