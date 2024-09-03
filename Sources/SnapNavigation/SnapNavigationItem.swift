//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable, Equatable {
	
    static var initial: Self { get }

    var subitems: [Self] { get }
	var path: SnapNavigation.State<Self>.Path { get }
	
    var title: String { get }
	@MainActor
    var label: any View { get }

    @MainActor
    var destination: any View { get }

}
