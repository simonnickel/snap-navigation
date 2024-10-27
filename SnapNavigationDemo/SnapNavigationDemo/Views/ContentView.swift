//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ContentView: View {

	var body: some View {
        SnapNavigationView(
			provider: NavigationProvider()
		)
        .tabViewSidebarHeader {
            Text("Header")
                .font(.headline)
                .fontWeight(.bold)
        }
        .tabViewSidebarFooter {
			VStack {
				Text("Footer")
				DeeplinkButton(title: "Rectangle", destination: .rectangle)
			}
			.font(.footnote)
        }
        .tabViewSidebarBottomBar {
			DeeplinkButton(title: "Circle 10", destination: .circleItem(level: 10))
        }
        .tint(.green)
	}
}

#Preview() {
	ContentView()
}
