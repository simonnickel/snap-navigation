//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
	
	/// A modifier to present multiple modals by recursively applying itself for each level of presentation visible.
	internal struct ModalPresentationModifier<NavigationProvider: SnapNavigationProvider>: ViewModifier {
		
		typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
		@Environment(NavigationManager.self) private var navigationManager
        
        @Environment(\.navigationElevationKeyPath) private var navigationElevationKeyPath
		
		private let elevationIteration: Elevation
		
		init(elevation: Elevation) {
			self.elevationIteration = elevation
		}
		
		func body(content: Content) -> some View {
			// ModalPresentationModifier has to start with highest visible elevation to recursively present modals.
			// Therefore it has to invert the elevation to get the correct bindings.
			let elevation = navigationManager.elevationInverted(elevationIteration)
			
			if elevation >= SnapNavigation.Constants.elevationMin {
				content
					.sheet(isPresented: navigationManager.modalBinding(for: elevation)) {
                        SnapNavigation.SceneView<NavigationProvider>(context: .modal(elevation: elevation))
							.modifier(ModalPresentationModifier(elevation: elevationIteration - 1))
							.environment(navigationManager)
                    }
                    .environment(\.navigationElevation, elevation)
                    .environment(navigationElevationKeyPath ?? \.navigationElevation, elevation)
            } else {
				content
			}
		}
		
	}
	
}
