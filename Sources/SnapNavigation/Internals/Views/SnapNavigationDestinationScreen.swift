//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationDestinationScreen<Screen: SnapNavigationScreen>: View {
	
	let screen: Screen
	
	var body: some View {
		
		AnyView(screen.destination)
			.navigationTitle(screen.definition.title)
		
	}
	
}
