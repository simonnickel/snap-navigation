//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

#if DEBUG

public struct SnapNavigationPreview<NavigationProvider: SnapNavigationProvider>: View {
	
	public typealias NavigationScene = SnapNavigation.NavigationScene<NavigationProvider>

	private let provider: NavigationProvider
	private let scene: NavigationScene
	
	public init(provider: NavigationProvider, scene: NavigationScene) {
		self.provider = provider
		self.scene = scene
	}
	
	public var body: some View {
		
		SnapNavigationView(provider: provider, scene: scene)
		
	}
	
}

#endif
