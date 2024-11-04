//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationSingleView<NavigationProvider: SnapNavigationProvider>: View {

	typealias Navigator = SnapNavigation.Navigator<NavigationProvider>

	@Bindable private var navigator: Navigator

	init(navigator: Navigator) {
		self.navigator = navigator
	}

	var body: some View {
		
		let selection = navigator.selected
		SnapNavigationStack<NavigationProvider>(context: .selection(destination: selection))
		
	}
	
}
