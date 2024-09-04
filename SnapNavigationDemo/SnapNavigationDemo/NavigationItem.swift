//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

enum NavigationItem: String, SnapNavigationItem {
	var id: String { self.rawValue }
		
	case triangle, rectangle, circle
    case circle1, circle2, circle3
    case infinity

	var definition: SnapNavigation.ItemDefinition {
        switch self {
			case .rectangle: .init(title: "Rectangle", systemImage: "rectangle")
            case .triangle: .init(title: "Triangle", systemImage: "triangle")
            case .circle: .init(title: "Circle", systemImage: "circle")

            case .circle1: .init(title: "Circle 1", systemImage: "1.circle")
            case .circle2: .init(title: "Circle 2", systemImage: "2.circle")
            case .circle3: .init(title: "Circle 3", systemImage: "3.circle")

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
