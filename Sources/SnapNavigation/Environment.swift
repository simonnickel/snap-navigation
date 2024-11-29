//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension EnvironmentValues {
    
    @Entry public var navigator: (SnapNavigation.NavigatorAction) -> Void = { _ in }

    @Entry public var isPresentingDestination: SnapNavigation.IsPresenting = { _ in false }
    
    @Entry public var navigationState: Int = 0
    
}
