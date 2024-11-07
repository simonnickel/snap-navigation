//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationContainer<NavigationProvider: SnapNavigationProvider>: View {
	
	internal typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
	
	@Environment(\.navigationStyle) private var navigationStyle

	let navigator: Navigator
	let navigatorTranslator: SnapNavigation.NavigatorTranslator
	
	init(navigator: Navigator) {
		self.navigator = navigator
		self.navigatorTranslator = navigator.translator
	}
	
	var body: some View {
		Group {
			switch navigationStyle ?? navigator.scene.style {
					
				case .single:
					SnapNavigationSingleView(navigator: navigator)
					
				case .tabsAdaptable:
					SnapNavigationTabView(navigator: navigator)
					
			}
		}
		.modifier(SnapNavigation.ModalPresentationModifier<NavigationProvider>(level: navigator.modalLevelCurrent))
		.environment(navigator)
		.environment(navigatorTranslator)
	}
	
}
