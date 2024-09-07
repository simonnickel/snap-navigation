//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ItemScreen: View {
	
	@Environment(SnapNavigation.State<NavigationItemProvider>.self) private var navigationState

	let item: NavigationItem
	
	var body: some View {
		VStack {
			
			DeeplinkButton(title: "Deeplink: Rectangle", item: .rectangle)
			DeeplinkButton(title: "Deeplink: Rectangle 3", item: .rectangleItem(level: 3))

			DeeplinkButton(title: "Deeplink: Circle", item: .circle)
			DeeplinkButton(title: "Deeplink: Circle 3", item: .circleItem(level: 3))

			NavigationLink(value: NavigationItem.infinity) {
				HStack {
					Text("NavigationLink:")
					AnyView(NavigationItem.infinity.label)
				}
			}
			.padding()
			
		}
	}
	
}
