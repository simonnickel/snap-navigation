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
    
    internal func isPresenting(_ destination: any SnapNavigationDestination, in context: PathContext) -> Bool {
        guard let translated = provider.translate(destination) else { return false }
        return state.isPresenting(translated, in: context)
    }
    
}

extension SnapNavigation.Navigator.State {
    
    internal func isPresenting(_ destination: Destination, in context: SnapNavigation.Navigator<NavigationProvider>.PathContext) -> Bool {
        switch context {
        case .modal(level: let level):
            guard modals.count > level else {
                return false
            }
            let modal = modals[level]
            
            return modal.path.contains(destination)
            
        case .selection(destination: let selection):
            guard let path = pathForSelection[selection] else {
                return false
            }
            
            return path.contains(destination)
        }
    }
    
}
