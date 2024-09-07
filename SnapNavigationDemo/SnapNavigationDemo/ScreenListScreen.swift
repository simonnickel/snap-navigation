//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ScreenListScreen: View {
	
	@Environment(SnapNavigation.State<NavigationProvider>.self) private var navigationState

    let screen: Screen

    var body: some View {
		List(navigationState.subscreens(for: screen)) { subscreen in
            NavigationLink(value: subscreen) {
                AnyView(subscreen.label)
            }
        }
    }

}
