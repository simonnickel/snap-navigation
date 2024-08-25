//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

class AppState: ObservableObject {

    @Published var navigationStyle: SnapNavigation.Style = .adaptable

}
