//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public extension SnapNavigation {
    
    typealias IsPresenting = (any SnapNavigationDestination) -> Bool
    
}

public extension EnvironmentValues {
    
    @Entry var isPresentingDestination: SnapNavigation.IsPresenting = { _ in false }
    
}

extension SnapNavigation.Navigator {
    
    internal func isPresenting(_ destination: any SnapNavigationDestination, in context: Scene.Context) -> Bool {
        guard let translated = provider.translate(destination) else { return false }
        return state.isPresenting(translated, in: context)
    }
    
}

extension SnapNavigation.Navigator.State {
    
    internal func isPresenting(_ destination: Destination, in context: Scene.Context) -> Bool {
        let path = getPath(for: context)
        return path.contains(destination)
    }
    
}
