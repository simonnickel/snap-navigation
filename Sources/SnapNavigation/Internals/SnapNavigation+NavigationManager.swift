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

		internal let navigationProvider: NavigationProvider
		
		internal init(provider: NavigationProvider) {
			self.navigationProvider = provider
		}
		
		internal var supportsMultipleWindows: Bool = false
		internal var openWindow: OpenWindowAction? = nil
		
		
		// MARK: - Navigator

		@MainActor
		private var navigatorForScene: [NavigationScene<NavigationProvider>: Navigator] = [:]
		
		@MainActor
		internal func navigator(for scene: NavigationScene<NavigationProvider>) -> Navigator {
			if let navigator = navigatorForScene[scene] {
				return navigator
			} else {
				let navigator = Navigator(navigationManager: self, scene: scene)
				navigatorForScene[scene] = navigator
				return navigator
			}
		}
		
		@MainActor
		internal func removeNavigator(for scene: NavigationScene<NavigationProvider>) {
			navigatorForScene.removeValue(forKey: scene)
		}
		
	}
	
}
