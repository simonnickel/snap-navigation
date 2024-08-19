//
//  SNAP - https://github.com/simonnickel/snap-abstract
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable, Equatable {
	
    var items: [Self] { get }
    var title: String { get }
    var label: any View { get }
    var destination: any View { get }

}
