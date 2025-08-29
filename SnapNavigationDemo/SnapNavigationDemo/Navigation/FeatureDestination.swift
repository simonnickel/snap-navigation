//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation
import SwiftUI

enum FeatureDestination: SnapNavigationDestination {
		
	case hexagon
	case pentagon
	
	var definition: SnapNavigation.ScreenDefinition {
		switch self {
				
			case .pentagon: .init(title: "Pentagon", icon: "pentagon") {
                DeeplinkScreen(destination: .feature(.pentagon))
            }
            
            case .hexagon: .init(title: "Hexagon", icon: "hexagon") {
                DeeplinkScreen(destination: .feature(.pentagon))
			}

		}
	}
    
    
    // MARK: Identifiable
    
    var id: Self { self }
    
	
	// MARK: Definition Overrides

	@MainActor
	var label: any View {
        Label(definition.title, systemImage: definition.icon as? String ?? "")
	}
	
	@MainActor
	var destination: any View {
		definition.destination?() ?? EmptyView()
	}
	
}
