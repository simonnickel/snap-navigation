//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationStack<Item: SnapNavigationItem>: View {

    let path: Binding<[Item]>
    let root: Item

    var body: some View {
        NavigationStack(path: path) {
            SnapNavigationDestinationScreen(item: root)
                .navigationDestination(for: Item.self) { item in
                    SnapNavigationDestinationScreen(item: item)
                }
        }
    }
    
}
