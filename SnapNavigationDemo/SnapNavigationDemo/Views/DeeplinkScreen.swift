//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation
import SwiftUI

struct DeeplinkScreen: View {
	
    @Environment(\.navigator) private var navigator
	@Environment(AppState.self) private var appState
    
    @Environment(\.isPresentingDestination) private var isPresentingDestination

	let destination: AppDestination
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 32) {
				VStack(alignment: .leading, spacing: 4) {
					Text("Deeplink").font(.headline)
					HStack {
						DeeplinkButton(title: "Rectangle", destination: .rectangle)
						DeeplinkButton(title: "Rectangle 2", destination: .rectangleItem(level: 2))
						DeeplinkButton(title: "Rectangle 3", destination: .rectangleItem(level: 3))
						DeeplinkButton(title: "Rectangle 7", destination: .rectangleItem(level: 7))
						DeeplinkButton(title: "Rectangle 8", destination: .rectangleItem(level: 8))
					}
					
					HStack {
						DeeplinkButton(title: "Circle", destination: .circle)
						DeeplinkButton(title: "Circle 3", destination: .circleItem(level: 3))
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Present").font(.headline)
					PresentButton(title: "Rectangle", destination: .rectangle)
					PresentButton(title: "Circle", destination: .circle)
					NavigationButton(title: "New single Window: .rectangle7") {
                        navigator(.window(destination: AppDestination.rectangleItem(level: 7), configuration: .init(shouldBuildRoute: false, style: .single)))
					}
					NavigationButton(title: "New single Window: Route .rectangle7") {
                        navigator(.window(destination: AppDestination.rectangleItem(level: 7), configuration: .init(shouldBuildRoute: true, style: .single)))
					}
					NavigationButton(title: "New tabs Window: Route .rectangle7") {
                        navigator(.window(destination: AppDestination.rectangleItem(level: 7), configuration: .init(shouldBuildRoute: true, style: .tabsAdaptable)))
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Push").font(.headline)
					NavigationButton(title: "Infinity") {
                        navigator(.present(AppDestination.infinity))
					}
					NavigationButton(title: "Any Feature Pentagon") {
						navigator(.present(FeatureDestination.pentagon))
					}
					NavigationButton(title: "Feature Hexagon") {
						navigator(.present(AppDestination.feature(.hexagon), style: .push))
					}
					
					NavigationLink(value: AppDestination.infinity) {
						Text("NavigationLink: Infinity")
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Dismiss").font(.headline)
					NavigationButton(title: "Pop to Root") {
                        navigator(.popCurrentToRoot)
					}
					NavigationButton(title: "Dismiss Current Modal") {
						navigator(.dismissCurrentModal)
					}
					NavigationButton(title: "Dismiss Modals") {
						navigator(.dismissModals)
					}
					
					NavigationLink(value: AppDestination.infinity) {
						Text("NavigationLink: Infinity")
					}
				}
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Style").font(.headline)
					NavigationButton(title: "Single") {
						appState.navigationStyle = .single
					}
					NavigationButton(title: "Tabs") {
						appState.navigationStyle = .tabsAdaptable
					}
				}
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Info").font(.headline)
                    Text("Contains .rectangleItem(2): \(isPresentingDestination(AppDestination.rectangleItem(level: 2)))")
                    Text("Contains .feature(.pentagon): \(isPresentingDestination(FeatureDestination.pentagon))")
                }
//                .onChange(of: navigator.stateHash) { oldValue, newValue in
//                    print("NavigationManager State hash changed: \(newValue)")
//                }
//                .onChange(of: navigatorTranslator.stateHash) { oldValue, newValue in
//                    print("Translator State hash changed: \(newValue)")
//                }
				
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.scenePadding()
		}
		// TODO FB15147353: TabView content behind toolbar. Adding `.offset(1)` or `.padding(1)` fixes it.
		.offset(y: 1)
		
	}
	
}

#Preview("Preview") {
    @Previewable let appState = AppState()
    
    DeeplinkScreen(destination: .circle)
        .environment(appState)
}

#Preview("SnapNavigationPreview Destination") {
    @Previewable let appState = AppState()
    
    SnapNavigationPreview(
        provider: NavigationProvider(),
        destination: AppDestination.circleItem(level: 2),
        configuration: .init(shouldBuildRoute: true, style: .tabsAdaptable)
    )
    .environment(appState)

}
