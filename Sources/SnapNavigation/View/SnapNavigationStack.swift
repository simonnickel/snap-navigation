//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationStack<NavigationProvider: SnapNavigationProvider>: View {

	typealias Screen = NavigationProvider.Screen
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
    let root: Screen

    var body: some View {
		NavigationStack(path: navigationState.pathBinding(for: root)) {
            SnapNavigationDestinationScreen(screen: root)
                .navigationDestination(for: Screen.self) { screen in
                    SnapNavigationDestinationScreen(screen: screen)
                }
        }
    }
    
}
