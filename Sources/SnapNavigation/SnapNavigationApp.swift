//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationApp<NavigationProvider: SnapNavigationProvider, WindowContent: View>: Scene {
	
	private typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
	public typealias Destination = NavigationProvider.Destination
	public typealias WindowSetupHandler = SnapNavigation.Window<Destination>.WindowSetupHandler<WindowContent>

	private let windowManager: WindowManager
	
	private let setupWindow: WindowSetupHandler?
	
	public init(provider: NavigationProvider, setupWindow: WindowSetupHandler? = nil) {
		self.windowManager = WindowManager(provider: provider)
		self.setupWindow = setupWindow
	}

	public var body: some Scene {
		WindowGroup {
            SnapNavigation.WindowView(windowManager: windowManager, window: .main, setup: setupWindow)
		}
		
		WindowGroup(for: SnapNavigation.Window<Destination>.self) { $window in
			if let window {
                SnapNavigation.WindowView(windowManager: windowManager, window: window, setup: setupWindow)
					.onDisappear() {
						// On Disappear is called when the window is closed.
                        windowManager.removeNavigationManager(for: window)
					}
			} else {
				EmptyView()
			}
		}
		
#if os(macOS)
		Settings {
            SnapNavigation.WindowView(windowManager: windowManager, window: .settings, setup: setupWindow)
		}
#endif
		
	}
}
