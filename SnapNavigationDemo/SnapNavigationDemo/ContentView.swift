//
//  ContentView.swift
//  SnapNavigationDemo
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI
import SnapNavigation

struct ContentView: View {
	
    let style: SnapNavigation.Style

    @State private var state = SnapNavigation.State(items: NavigationItem.itemsForTabBar)

	var body: some View {
        SnapNavigationView(
            state: $state,
			style: style
		)
        .tabViewSidebarHeader {
            Text("Header")
                .font(.headline)
                .fontWeight(.bold)
        }
        .tabViewSidebarFooter {
            Text("Footer")
                .font(.footnote)
        }
        .tabViewSidebarBottomBar {
            Button {
                state.selected = .circle
                state.setPath([.triangle, .rectangle], for: .circle)
            } label: {
                Text("Circle > Tri > Rect")
            }
        }
        .tint(.green)
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
