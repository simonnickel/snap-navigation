//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct DeeplinkScreen: View {
	
	@Environment(Navigator.self) private var navigator

	let screen: Screen
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 32) {
				VStack(alignment: .leading, spacing: 4) {
					Text("Deeplink").font(.headline)
					HStack {
						DeeplinkButton(title: "Rectangle", screen: .rectangle)
						DeeplinkButton(title: "Rectangle 2", screen: .rectangleItem(level: 2))
						DeeplinkButton(title: "Rectangle 3", screen: .rectangleItem(level: 3))
						DeeplinkButton(title: "Rectangle 7", screen: .rectangleItem(level: 7))
						DeeplinkButton(title: "Rectangle 8", screen: .rectangleItem(level: 8))
					}
					
					HStack {
						DeeplinkButton(title: "Circle", screen: .circle)
						DeeplinkButton(title: "Circle 3", screen: .circleItem(level: 3))
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Present").font(.headline)
					PresentButton(title: "Rectangle", screen: .rectangle)
					PresentButton(title: "Circle", screen: .circle)
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Push").font(.headline)
					PushButton(title: "Infinity", screen: .infinity)
					
					NavigationLink(value: Screen.infinity) {
						Text("NavigationLink: Infinity")
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Dismiss").font(.headline)
					NavigationButton(title: "Pop to Root") {
						navigator.popCurrentToRoot()
					}
					NavigationButton(title: "Dismiss Current Modal") {
						navigator.dismissCurrentModal()
					}
					NavigationButton(title: "Dismiss Modals") {
						navigator.dismissModals()
					}
					
					NavigationLink(value: Screen.infinity) {
						Text("NavigationLink: Infinity")
					}
				}
				
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.scenePadding()
		}
		// TODO FB15147353: TabView content behind toolbar. Adding `.offset(1)` or `.padding(1)` fixes it.
		.offset(y: 1)
		
	}
	
}
