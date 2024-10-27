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
			ForEach(navigator.destinations) { destination in
				
				tab(for: destination)
				
			}
		}
		.tabViewStyle(.sidebarAdaptable)
		
	}
	
	
	// MARK: Tab View
	
	@TabContentBuilder<NavigationProvider.Destination>
	private func tab(for destination: NavigationProvider.Destination) -> some TabContent<NavigationProvider.Destination> {
		Tab(value: destination, role: nil) {
			SnapNavigationStack<NavigationProvider>(context: .selection(destination: destination))
		} label: {
			AnyView(destination.label)
		}
	}
	
}
