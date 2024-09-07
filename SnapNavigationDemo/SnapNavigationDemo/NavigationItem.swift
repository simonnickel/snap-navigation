//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum NavigationItem: SnapNavigationItem {
		
	case triangle
	case rectangle, rectangleItem(level: Int)
	case circle, circleSection, circleItem(level: Int)
    case infinity

	var definition: SnapNavigation.ItemDefinition<Self> {
        switch self {
				
			case .triangle: .init(title: "Triangle", systemImage: "triangle")
				
			case .rectangle: .init(title: "Rectangle", systemImage: "rectangle")
				
			case .rectangleItem(level: let level): .init(title: "Rectangle \(level)", systemImage: "\(level).rectangle")
				
            case .circle: .init(title: "Circle", systemImage: "circle") { item in
				ItemList(item: item)
			}
				
			case .circleSection: .init(title: "Circles", systemImage: "circle")
				
			case .circleItem(level: let level): .init(title: "Circle \(level)", systemImage: "\(level).circle")
            
            case .infinity: .init(title: "Infinity", systemImage: "infinity")
				
        }
    }

	var label: any View {
		definition.label
	}
	
	var destination: any View {
		definition.destination?(self) ?? ItemScreen(item: self)
	}
	
}
