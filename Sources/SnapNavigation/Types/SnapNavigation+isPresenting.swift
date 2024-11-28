//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    public typealias IsPresenting = (any SnapNavigationDestination) -> Bool
    
}

extension EnvironmentValues {
    
    @Entry public var isPresentingDestination: SnapNavigation.IsPresenting = { _ in false }
    
}

extension SnapNavigation.NavigationManager {
    
    internal func isPresenting(_ destination: any SnapNavigationDestination, in context: Scene.Context) -> Bool {
        guard let translated = provider.translate(destination) else { return false }
        return state.isPresenting(translated, in: context)
    }
    
}

extension SnapNavigation.NavigationManager.State {
    
    internal func isPresenting(_ destination: Destination, in context: Scene.Context) -> Bool {
        let path = getPath(for: context)
        return path.contains(destination)
    }
    
}
