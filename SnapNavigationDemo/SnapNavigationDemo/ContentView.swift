//
//  ContentView.swift
//  SnapNavigationDemo
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI
import SnapNavigation

struct ContentView: View {
	
	let style: SnapNavigationStyle
	
	var body: some View {
		SnapNavigationContainer(
			items: NavigationItem.itemsForTabBar,
			initial: .rectangle,
			style: style
		)
	}
}

#Preview("Adaptable") {
	ContentView(style: .adaptable)
}

#Preview("Sidebar") {
	ContentView(style: .sidebar)
}

#Preview("Tab") {
	ContentView(style: .tab)
}

#Preview("Dynamic") {
	ContentView(style: .dynamic)
}
