//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation
import SwiftUI

enum AppDestination: SnapNavigationDestination {
		
	case triangle
	case rectangle, rectangleItem(level: Int)
	case circle, circleItem(level: Int)
    case infinity
	
	case settings
	case feature(_ destination: FeatureDestination)

	var definition: SnapNavigation.ScreenDefinition {
        switch self {
				
			case .triangle: .init(title: "Triangle", icon: "triangle")
				
			case .rectangle: .init(title: "Rectangle", icon: "rectangle")
				
			case .rectangleItem(level: let level): .init(
				title: "Rectangle \(level)",
				icon: "\(level).rectangle",
				style: level % 3 == 0 ? .modal : .push
			) {
				DeeplinkScreen(destination: self)
			}
				
            case .circle: .init(title: "Circle", icon: "circle")
				
			case .circleItem(level: let level): .init(title: "Circle \(level)", icon: "\(level).circle")
            
            case .infinity: .init(title: "Infinity", icon: "infinity")
				
			case .settings: .init(title: "Settings", icon: "gear") { Text("Settings").frame(width: 300, height: 200) }
				
			case .feature(let destination): destination.definition
				
        }
    }
	
	
	// MARK: Definition Overrides

	@MainActor
	var label: any View {
        Label(definition.title, systemImage: definition.icon as? String ?? "")
	}
	
	@MainActor
	var destination: any View {
		definition.destination?() ?? DeeplinkScreen(destination: self)
	}
	
}
