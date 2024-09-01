//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ContentView: View {

    private var state = SnapNavigation.State(items: NavigationItem.itemsForTabBar)

	var body: some View {
        SnapNavigationView(
            state: state
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
                state.setPath([.rectangle, .circle], for: .triangle)
                state.selected = .circle
            } label: {
                Text("Tri > Rect > Circ")
            }
        }
        .tint(.green)
	}
}

#Preview() {
	ContentView()
}
