//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationTabView<NavigationProvider: SnapNavigationProvider>: View {

	typealias Navigator = SnapNavigation.Navigator<NavigationProvider>

    @Bindable private var navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

	var body: some View {
		
		TabView(selection: $navigator.selected) {
			ForEach(navigator.screens) { screen in
				
				tab(for: screen)
				
			}
		}
		.tabViewStyle(.sidebarAdaptable)
		
	}
	
	
	// MARK: Tab View
	
	@TabContentBuilder<NavigationProvider.Screen>
	private func tab(for screen: NavigationProvider.Screen) -> some TabContent<NavigationProvider.Screen> {
		Tab(value: screen, role: nil) {
			SnapNavigationStack<NavigationProvider>(context: .selection(screen: screen))
		} label: {
			AnyView(screen.label)
		}
	}
	
}
