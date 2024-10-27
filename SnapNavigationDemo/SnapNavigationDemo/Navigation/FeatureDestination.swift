//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum FeatureDestination: SnapNavigationDestination {
		
	case hexagon
	case pentagon
	
	var definition: SnapNavigation.ScreenDefinition {
		switch self {
				
				// An example with a destination factory using the destination.
			case .pentagon: .init(title: "Pentagon", icon: "pentagon") {
				Text("Pentagon")
			}
			
				// An example with a destination factory not using the destination.
			case .hexagon: .init(title: "Hexagon", icon: "hexagon") { destination in
				FeatureView(destination: destination)
			}

		}
	}
	
	
	// MARK: Definition Overrides

	@MainActor
	var label: any View {
		definition.label
	}
	
	@MainActor
	var destination: any View {
		definition.destination?(self) ?? EmptyView()
	}
	
}

struct FeatureView: View {
	
	let destination: FeatureDestination
	
	var body: some View {
		AnyView(destination.label)
	}
	
}
