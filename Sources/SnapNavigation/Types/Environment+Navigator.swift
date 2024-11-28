//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension EnvironmentValues {
    
    @Entry public var navigator: (SnapNavigation.Action) -> Void = { _ in }
    
}
