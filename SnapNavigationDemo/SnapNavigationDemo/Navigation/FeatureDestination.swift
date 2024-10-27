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
				
			case .pentagon: .init(title: "Pentagon", icon: "pentagon") {
				FeatureView(destination: self)
			}
			
			case .hexagon: .init(title: "Hexagon", icon: "hexagon") {
				FeatureView(destination: self)
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
		definition.destination?() ?? EmptyView()
	}
	
}

struct FeatureView: View {
	
	let destination: FeatureDestination
	
	var body: some View {
		AnyView(destination.label)
	}
	
}
