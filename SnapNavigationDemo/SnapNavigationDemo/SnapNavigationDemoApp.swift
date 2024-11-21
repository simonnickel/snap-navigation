//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation
import SwiftUI

@Observable class AppState {
	var navigationStyle: SnapNavigation.NavigationStyle = .tabsAdaptable
}

@main
struct SnapNavigationDemoApp: App {
	
	private let appState = AppState()
	
    var body: some Scene {
		
		SnapNavigationApp(provider: NavigationProvider()) { window, content in
			content
				.navigationStyle(window == .main ? appState.navigationStyle : nil)
				.environment(appState)
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
	
}

#Preview {
	@Previewable let appState = AppState()
	
    SnapNavigationPreview(provider: NavigationProvider())
        .navigationStyle(.tabsAdaptable)
        .environment(appState)
}
