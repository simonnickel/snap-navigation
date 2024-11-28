//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationSingleView<NavigationProvider: SnapNavigationProvider>: View {

	typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>

	private var navigationManager: NavigationManager

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}

	var body: some View {
		
		let selection = navigationManager.selected
		SnapNavigationScene<NavigationProvider>(context: .selection(destination: selection))
		
	}
	
}
