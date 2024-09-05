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
			
			DeeplinkButton(title: "Deeplink: Circle 4", item: .circleItem(level: 4))
			DeeplinkButton(title: "Deeplink: Rectangle", item: .rectangle)

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
