//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationTabView<NavigationProvider: SnapNavigationProvider>: View {

	typealias NavState = SnapNavigation.State<NavigationProvider>

    @Environment(\.horizontalSizeClass) private var horizontalSize

    @Bindable private var state: NavState

    init(state: NavState) {
        self.state = state
    }

	var body: some View {
		
		TabView(selection: $state.selected) {
			ForEach(state.screens) { screen in
				
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
