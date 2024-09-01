//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

public extension SnapNavigation {

    /// Different styles of navigation that are supported.
    public enum Style: String, Identifiable, CaseIterable {
        public var id: Self { self }

        case tab, sidebar, adaptable, dynamic

        /// True if the style is expected to maintain the path of each top level item.
        var shouldMaintainPath: Bool {
            switch self {
            case .tab, .adaptable, .dynamic: true
            case .sidebar: false
            }
        }
    }
    
}
