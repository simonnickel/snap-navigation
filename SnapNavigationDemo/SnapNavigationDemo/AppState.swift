//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

class AppState: ObservableObject {

    static var navigationStyleInitial: SnapNavigation.Style { .adaptable }

    @Published var navigationStyle: SnapNavigation.Style = AppState.navigationStyleInitial

}
