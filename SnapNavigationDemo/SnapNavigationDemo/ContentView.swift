//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ContentView: View {

    @StateObject private var appState: AppState = AppState()

    @State private var state = SnapNavigation.State(items: NavigationItem.itemsForTabBar)

    @State private var navigationStyle: SnapNavigation.Style = .adaptable

	var body: some View {
        SnapNavigationView(
            state: state,
            style: appState.navigationStyle
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
        .environmentObject(appState)
	}
}

#Preview() {
	ContentView()
}
