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

	var definition: SnapNavigation.ItemDefinition<Self> {
        switch self {
				
			case .rectangle: .init(title: "Rectangle", systemImage: "rectangle")
			
            case .triangle: .init(title: "Triangle", systemImage: "triangle")
				
            case .circle: .init(title: "Circle", systemImage: "circle") { item in
				ItemList(item: item)
			}

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
