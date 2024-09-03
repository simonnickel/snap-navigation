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

    static var itemsForTabBar: [Self] { [.triangle, .rectangle, .circle] }
    static var initial: NavigationItem { .rectangle }

    var subitems: [Self] {
        switch self {
			case .circle: [.circle, .circle1, .circle2, .circle3]
            default: []
        }
    }
	
	var path: SnapNavigation.State<Self>.Path {
		switch self {
			case .circle1: [.triangle]
			case .circle2: [.triangle, .circle1]
			case .circle3: [.triangle, .circle1, .circle2]
			default: []
		}
	}

    var title: String {
        switch self {
            case .rectangle: "Rectangle"
            case .triangle: "Triangle"
            case .circle: "Circle"

            case .circle1: "Circle 1"
            case .circle2: "Circle 2"
            case .circle3: "Circle 3"

            case .infinity: "Infinity"
        }
    }

    var systemImage: String {
        switch self {
            case .rectangle: "rectangle"
            case .circle: "circle"
            case .triangle: "triangle"

            case .circle1: "1.circle"
            case .circle2: "2.circle"
            case .circle3: "3.circle"
            
            case .infinity: "infinity"
        }
    }

	@MainActor
	var label: any View {
		Label(title, systemImage: systemImage)
	}

    @MainActor
	var destination: any View {
		switch self {
            case .triangle: ItemScreen(item: self)
            case .rectangle: ItemScreen(item: self)
            case .circle: ItemList(item: self)

            default: ItemScreen(item: self)
		}
	}
	
}
