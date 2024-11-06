//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationScene<NavigationProvider: SnapNavigationProvider, SceneContent: View>: View {
	
	internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
	internal typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider.Destination>
	internal typealias SceneSetup = NavigationProvider.SceneSetup<SceneContent>
	
	private let manager: NavigationManager
	private let scene: NavigationScene
	private let setup: SceneSetup?
	
	internal init(manager: NavigationManager, scene: NavigationScene, setup: SceneSetup? = nil) {
		self.manager = manager
		self.scene = scene
		self.setup = setup
	}
	
	var body: some View {
		
		if let setup {
			setup(scene, SnapNavigationView(manager: manager, scene: scene))
		} else {
			SnapNavigationView(manager: manager, scene: scene)
		}
		
	}
	
}