//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationWindows<NavigationProvider: SnapNavigationProvider, SceneContent: View>: Scene {
	
	private typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>

	private let manager: NavigationManager
	
	public typealias SceneSetup = (SnapNavigation.NavigationScene<NavigationProvider.Destination>, SnapNavigationView<NavigationProvider>) -> SceneContent
	private let setupScene: SceneSetup?
	
	public init(provider: NavigationProvider, setupScene: SceneSetup? = nil) {
		self.manager = NavigationManager(provider: provider)
		self.setupScene = setupScene
	}

	public var body: some Scene {
		WindowGroup {
			SnapNavigationScene(manager: manager, scene: .main, setup: setupScene)
		}
		
		WindowGroup(for: SnapNavigation.NavigationScene<NavigationProvider.Destination>.self) { $scene in
			if let scene {
				SnapNavigationScene(manager: manager, scene: scene, setup: setupScene)
					.onDisappear() {
						// On Disappear is called when the window is closed.
						manager.removeNavigator(for: scene)
					}
			} else {
				EmptyView()
			}
		}
		
#if os(macOS)
		Settings {
			SnapNavigationScene(manager: manager, scene: .settings, setup: setupScene)
		}
#endif
		
	}
}
