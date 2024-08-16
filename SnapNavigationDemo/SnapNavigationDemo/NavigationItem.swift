//
//  NavigationItem.swift
//  SnapNavigationDemo
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI
import SnapNavigation

enum NavigationItem: String, SnapNavigationItem {
	var id: String { self.rawValue }
		
	case rectangle, circle, triangle
	
	static var itemsForTabBar: [Self] { [.rectangle, .circle] }
	
	var label: any View {
		switch self {
			case .rectangle: Label("Rectangle", systemImage: "rectangle")
			case .circle: Label("Circle", systemImage: "circle")
			case .triangle: Label("Triangle", systemImage: "triangle")
		}
	}
	
	var destination: any View {
		switch self {
			case .rectangle: ItemScreen(item: self)
			case .circle: ItemScreen(item: self)
			case .triangle: ItemScreen(item: self)
		}
	}
	
}
