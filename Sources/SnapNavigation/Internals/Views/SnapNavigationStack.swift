//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationStack<NavigationProvider: SnapNavigationProvider>: View {

	typealias Screen = NavigationProvider.Screen
	
	typealias NavigationState = SnapNavigation.State<NavigationProvider>
	@Environment(NavigationState.self) private var navigationState
	
	let context: NavigationState.PathContext

    var body: some View {
		
		NavigationStack(path: navigationState.pathBinding(for: context)) {
			
			if let root = navigationState.root(for: context) {
				
				SnapNavigationDestinationScreen(screen: root)
					.navigationDestination(for: Screen.self) { screen in
						SnapNavigationDestinationScreen(screen: screen)
					}
				
			}
			
        }
		
    }
    
}
