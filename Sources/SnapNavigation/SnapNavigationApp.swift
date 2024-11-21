//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationApp<NavigationProvider: SnapNavigationProvider, WindowContent: View>: Scene {
	
	private typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
	public typealias Destination = NavigationProvider.Destination
	public typealias WindowSetupHandler = SnapNavigation.Window<Destination>.WindowSetupHandler<WindowContent>

	private let manager: WindowManager
	
	private let setupWindow: WindowSetupHandler?
	
	public init(provider: NavigationProvider, setupWindow: WindowSetupHandler? = nil) {
		self.manager = WindowManager(provider: provider)
		self.setupWindow = setupWindow
	}

	public var body: some Scene {
		WindowGroup {
            SnapNavigation.WindowView(manager: manager, window: .main, setup: setupWindow)
		}
		
		WindowGroup(for: SnapNavigation.Window<Destination>.self) { $window in
			if let window {
                SnapNavigation.WindowView(manager: manager, window: window, setup: setupWindow)
					.onDisappear() {
						// On Disappear is called when the window is closed.
						manager.removeNavigator(for: window)
					}
			} else {
				EmptyView()
			}
		}
		
#if os(macOS)
		Settings {
            SnapNavigation.WindowView(manager: manager, window: .settings, setup: setupWindow)
		}
#endif
		
	}
}
