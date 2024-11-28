//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationScene<NavigationProvider: SnapNavigationProvider>: View {

    typealias Destination = NavigationProvider.Destination
    typealias Scene = SnapNavigation.Scene<Destination>
	
	typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
	@Environment(NavigationManager.self) private var navigationManager
	
    let context: Scene.Context

    var body: some View {
        
        NavigationStack(path: navigationManager.pathBinding(for: context)) {
            
            if let root = navigationManager.root(for: context) {
                
                SnapNavigationDestinationScreen(destination: root)
                    .navigationDestination(for: Destination.self) { destination in
                        SnapNavigationDestinationScreen(destination: destination)
                    }
                
            }
            
        }
        .environment(\.isPresentingDestination, { destination in
            navigationManager.isPresenting(destination, in: context)
        })
        
    }
    
}
