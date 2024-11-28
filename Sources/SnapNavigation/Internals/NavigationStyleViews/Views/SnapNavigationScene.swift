//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationScene<NavigationProvider: SnapNavigationProvider>: View {

    typealias Destination = NavigationProvider.Destination
    typealias Scene = SnapNavigation.Scene<Destination>
	
	typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
	@Environment(Navigator.self) private var navigator
	
    let context: Scene.Context

    var body: some View {
        
        NavigationStack(path: navigator.pathBinding(for: context)) {
            
            if let root = navigator.root(for: context) {
                
                SnapNavigationDestinationScreen(destination: root)
                    .navigationDestination(for: Destination.self) { destination in
                        SnapNavigationDestinationScreen(destination: destination)
                    }
                
            }
            
        }
        .environment(\.isPresentingDestination, { destination in
            navigator.isPresenting(destination, in: context)
        })
        
    }
    
}