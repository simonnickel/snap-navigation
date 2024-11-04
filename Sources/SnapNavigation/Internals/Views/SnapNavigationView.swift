//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

// Has to be public to be available in SceneSetup closure.
public struct SnapNavigationView<NavigationProvider: SnapNavigationProvider>: View {

    internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
	internal typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider>

	private let manager: NavigationManager
	private let scene: NavigationScene

	internal init(manager: NavigationManager, scene: NavigationScene) {
        self.manager = manager
		self.scene = scene
    }
	
	/// For Previews where multi-window is not needed.
	internal init(provider: NavigationProvider, scene: NavigationScene) {
		self.init(manager: NavigationManager(provider: provider), scene: scene)
	}

	public var body: some View {

		SnapNavigationContainer(navigator: manager.navigator(for: scene))
        
    }
    
}
