//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable, Equatable {
	
    static var initial: Self { get }

    var items: [Self] { get }
    var title: String { get }
    var label: any View { get }
    var destination: any View { get }

}
