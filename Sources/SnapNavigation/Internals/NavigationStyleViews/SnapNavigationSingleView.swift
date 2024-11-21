//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationSingleView<NavigationProvider: SnapNavigationProvider>: View {

	typealias Navigator = SnapNavigation.Navigator<NavigationProvider>

	private var navigator: Navigator

	init(navigator: Navigator) {
		self.navigator = navigator
	}

	var body: some View {
		
		let selection = navigator.selected
		SnapNavigationScene<NavigationProvider>(context: .selection(destination: selection))
		
	}
	
}
