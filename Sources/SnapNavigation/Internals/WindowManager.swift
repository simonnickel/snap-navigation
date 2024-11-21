//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftUI

extension SnapNavigation {
	
    /// Manages multiple `Window`s by providing a `Navigator` for them, which windows are open is managed by SwiftUI.
	final internal class WindowManager<NavigationProvider: SnapNavigationProvider> {
		
		internal typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
		internal typealias Destination = NavigationProvider.Destination
		internal typealias Window = SnapNavigation.Window<NavigationProvider.Destination>

		internal let navigationProvider: NavigationProvider
		
		internal init(provider: NavigationProvider) {
			self.navigationProvider = provider
		}
		
		
		// MARK: - Navigator

		@MainActor
		private var navigatorForWindow: [Window: Navigator] = [:]
		
		@MainActor
		internal func navigator(for window: Window, supportsMultipleWindows: Bool, openWindow: OpenWindowAction) -> Navigator {
			if let navigator = navigatorForWindow[window] {
                /// Should usually not really be necessary. But for correctness, stability and future proofing this is called in case anything changed.
                navigator.update(supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)
				return navigator
			} else {
				let navigator = Navigator(provider: navigationProvider, window: window, supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)
				navigatorForWindow[window] = navigator
				return navigator
			}
		}
		
		@MainActor
		internal func removeNavigator(for window: Window) {
			navigatorForWindow.removeValue(forKey: window)
		}
		
	}
	
}
