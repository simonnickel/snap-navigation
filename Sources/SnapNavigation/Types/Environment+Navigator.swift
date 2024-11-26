//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public extension EnvironmentValues {
    
    @Entry var navigator: (SnapNavigation.Action) -> Void = { _ in }
    
}
