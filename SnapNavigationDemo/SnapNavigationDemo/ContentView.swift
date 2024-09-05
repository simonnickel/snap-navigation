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
			VStack {
				Text("Footer")
				DeeplinkButton(title: "Deeplink: Rectangle", item: .rectangle)
			}
			.font(.footnote)
        }
        .tabViewSidebarBottomBar {
			DeeplinkButton(title: "Deeplink: Circle 10", item: .circleItem(level: 10))
        }
        .tint(.green)
	}
}

#Preview() {
	ContentView()
}
