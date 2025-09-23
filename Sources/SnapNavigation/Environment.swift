//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension EnvironmentValues {
    
    @Entry public var navigator: (SnapNavigation.NavigatorAction) -> Void = { _ in }

    @Entry public var isPresentingDestination: SnapNavigation.IsPresenting = { _ in false }
    
    @Entry public var navigationState: Int = 0
    
    @Entry public var navigationElevation: SnapNavigation.ModalLevel = 0
    
    /// Set a `KeyPath` that points to a different `EnvironmentValue` SnapNavigation is supposed to set the Elevation to. Necessary to provide the elevation to a different package that should not now about SnapNavigation.
    @Entry public var navigationElevationKeyPath: WritableKeyPath<EnvironmentValues, SnapNavigation.ModalLevel>? = nil
    
}
