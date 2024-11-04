//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationScene<NavigationProvider: SnapNavigationProvider, SceneContent: View>: View {
	
	@Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
	@Environment(\.openWindow) private var openWindow
	
	internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
	internal typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider>
	internal typealias SceneSetup = SnapNavigationWindows<NavigationProvider, SceneContent>.SceneSetup
	
	private let manager: NavigationManager
	private let scene: NavigationScene
	private let setup: SceneSetup?
	
	internal init(manager: NavigationManager, scene: NavigationScene, setup: SceneSetup? = nil) {
		self.manager = manager
		self.scene = scene
		self.setup = setup
	}
	
	var body: some View {
		
		Group {
			if let setup {
				setup(scene, SnapNavigationView(manager: manager, scene: scene))
			} else {
				SnapNavigationView(manager: manager, scene: scene)
			}
		}
		.onAppear {
			manager.supportsMultipleWindows = supportsMultipleWindows
			manager.openWindow = openWindow
		}
		
	}
	
}
