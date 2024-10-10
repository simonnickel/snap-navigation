//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationStack<NavigationProvider: SnapNavigationProvider>: View {

	typealias Screen = NavigationProvider.Screen
	
	typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
	@Environment(Navigator.self) private var navigator
	
	let context: Navigator.PathContext

    var body: some View {
		
		NavigationStack(path: navigator.pathBinding(for: context)) {
			
			if let root = navigator.root(for: context) {
				
				SnapNavigationDestinationScreen(screen: root)
					.navigationDestination(for: Screen.self) { screen in
						SnapNavigationDestinationScreen(screen: screen)
					}
				
			}
			
        }
		
    }
    
}
