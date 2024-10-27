//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum AppDestination: SnapNavigationDestination {
		
	case triangle
	case rectangle, rectangleItem(level: Int)
	case circle, circleItem(level: Int)
    case infinity
	
	case feature(_ destination: FeatureDestination)

	var definition: SnapNavigation.ScreenDefinition {
        switch self {
				
			case .triangle: .init(title: "Triangle", icon: "triangle")
				
			case .rectangle: .init(title: "Rectangle", icon: "rectangle")
				
			case .rectangleItem(level: let level): .init(
				title: "Rectangle \(level)",
				icon: "\(level).rectangle",
				style: level % 3 == 0 ? .modal : .push
			) { destination in
				DeeplinkScreen(destination: destination)
			}
				
            case .circle: .init(title: "Circle", icon: "circle")
				
			case .circleItem(level: let level): .init(title: "Circle \(level)", icon: "\(level).circle")
            
            case .infinity: .init(title: "Infinity", icon: "infinity")
				
//			case .feature(let destination): destination.definition
			case .feature(let destination): .init(
				title: destination.definition.title,
				icon: destination.definition.icon,
				style: destination.definition.presentationStyle) {
					destination.definition.destination?(destination) ?? EmptyView()
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
		definition.destination?(self) ?? DeeplinkScreen(destination: self)
	}
	
}
