//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum NavigationItem: SnapNavigationItem {
	
	var id: Int { self.hashValue }
		
	case triangle, rectangle, circle
	case circleItem(level: Int)
    case infinity

	var definition: SnapNavigation.ItemDefinition {
        switch self {
			case .rectangle: .init(title: "Rectangle", systemImage: "rectangle")
            case .triangle: .init(title: "Triangle", systemImage: "triangle")
            case .circle: .init(title: "Circle", systemImage: "circle")

			case .circleItem(level: let level): .init(title: "Circle \(level)", systemImage: "\(level).circle")
            
            case .infinity: .init(title: "Infinity", systemImage: "infinity")
        }
    }

	var label: any View {
		definition.label
	}

	var destination: any View {
		switch self {
            case .triangle: ItemScreen(item: self)
            case .rectangle: ItemScreen(item: self)
            case .circle: ItemList(item: self)

            default: ItemScreen(item: self)
		}
	}
	
}
