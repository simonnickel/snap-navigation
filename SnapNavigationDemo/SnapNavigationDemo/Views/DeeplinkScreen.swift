//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct DeeplinkScreen: View {
	
	@Environment(NavigationState.self) private var navigationState

	let screen: Screen
	
	var body: some View {
		VStack {
			
			PresentButton(title: "Present: Rectangle", screen: .rectangle)
			DeeplinkButton(title: "Deeplink: Rectangle", screen: .rectangle)
			DeeplinkButton(title: "Deeplink: Rectangle 3", screen: .rectangleItem(level: 3))

			DeeplinkButton(title: "Deeplink: Circle", screen: .circle)
			DeeplinkButton(title: "Deeplink: Circle 3", screen: .circleItem(level: 3))

			NavigationLink(value: Screen.infinity) {
				HStack {
					Text("NavigationLink:")
					AnyView(Screen.infinity.label)
				}
			}
			.padding()
			
		}
	}
	
}
