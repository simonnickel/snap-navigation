//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftUI

extension SnapNavigation {
	
    /// Manages multiple `Window`s by providing a `NavigationManager` for them, which windows are open is managed by SwiftUI.
	final internal class WindowManager<NavigationProvider: SnapNavigationProvider> {
		
		internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
		internal typealias Destination = NavigationProvider.Destination
		internal typealias Window = SnapNavigation.Window<Destination>

		internal let navigationProvider: NavigationProvider
		
		internal init(provider: NavigationProvider) {
			self.navigationProvider = provider
		}
		
		
		// MARK: - NavigationManager

		@MainActor
		private var navigationManagerForWindow: [Window: NavigationManager] = [:]
		
		@MainActor
		internal func navigationManager(for window: Window, supportsMultipleWindows: Bool, openWindow: OpenWindowAction) -> NavigationManager {
			if let navigationManager = navigationManagerForWindow[window] {
                /// Should usually not really be necessary. But for correctness, stability and future proofing this is called in case anything changed.
                navigationManager.update(supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)
				return navigationManager
			} else {
				let navigationManager = NavigationManager(provider: navigationProvider, window: window, supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)
                navigationManagerForWindow[window] = navigationManager
				return navigationManager
			}
		}
		
		@MainActor
		internal func removeNavigationManager(for window: Window) {
            navigationManagerForWindow.removeValue(forKey: window)
		}
		
	}
	
}
