//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum Screen: SnapNavigationScreen {
		
	case triangle
	case rectangle, rectangleItem(level: Int)
	case circle, circleItem(level: Int)
    case infinity

	var definition: SnapNavigation.ScreenDefinition<Self> {
        switch self {
				
			case .triangle: .init(title: "Triangle", icon: "triangle")
				
			case .rectangle: .init(title: "Rectangle", icon: "rectangle")
				
			case .rectangleItem(level: let level): .init(
				title: "Rectangle \(level)",
				icon: "\(level).rectangle",
				style: level % 3 == 0 ? .modal : .push
			)
				
            case .circle: .init(title: "Circle", icon: "circle")
				
			case .circleItem(level: let level): .init(title: "Circle \(level)", icon: "\(level).circle")
            
            case .infinity: .init(title: "Infinity", icon: "infinity")
				
        }
    }
	
	
	// MARK: Definition Overrides

	@MainActor
	var label: any View {
		definition.label
	}
	
	@MainActor
	var destination: any View {
		definition.destination?(self) ?? DeeplinkScreen(screen: self)
	}
	
}
