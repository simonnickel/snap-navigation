//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ContentView: View {

	private var state = SnapNavigation.State(itemProvider: NavigationItemProvider())

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
				state.navigate(to: .circleItem(level: 10))
            } label: {
                Text("Deeplink: Circle 10")
            }
        }
        .tint(.green)
	}
}

#Preview() {
	ContentView()
}
