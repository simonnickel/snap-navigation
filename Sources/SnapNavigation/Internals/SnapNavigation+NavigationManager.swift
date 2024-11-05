//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftUI

extension SnapNavigation {
	
	final internal class NavigationManager<NavigationProvider: SnapNavigationProvider> {
		
		internal typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
		internal typealias Destination = NavigationProvider.Destination
		internal typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider.Destination>

		internal let navigationProvider: NavigationProvider
		
		internal init(provider: NavigationProvider) {
			self.navigationProvider = provider
		}
		
		
		// MARK: - Navigator

		@MainActor
		private var navigatorForScene: [NavigationScene: Navigator] = [:]
		
		@MainActor
		internal func navigator(for scene: NavigationScene, supportsMultipleWindows: Bool, openWindow: OpenWindowAction) -> Navigator {
			if let navigator = navigatorForScene[scene] {
				return navigator
			} else {
				let navigator = Navigator(provider: navigationProvider, scene: scene, supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)
				navigatorForScene[scene] = navigator
				return navigator
			}
		}
		
		@MainActor
		internal func removeNavigator(for scene: NavigationScene) {
			navigatorForScene.removeValue(forKey: scene)
		}
		
	}
	
}
