//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationStack<Screen: SnapNavigationScreen>: View {

    let path: Binding<[Screen]>
    let root: Screen

    var body: some View {
        NavigationStack(path: path) {
            SnapNavigationDestinationScreen(screen: root)
                .navigationDestination(for: Screen.self) { screen in
                    SnapNavigationDestinationScreen(screen: screen)
                }
        }
    }
    
}
