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
			Text(item.definition.title)
			
			Button {
				navigationState.navigate(to: .circleItem(level: 4))
			} label: {
				Text("Button Deeplink: Circle 4")
			}
			.padding()
			
			Button {
				navigationState.navigate(to: .rectangle)
			} label: {
				Text("Button Deeplink: Rectangle")
			}
			.padding()

			
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
