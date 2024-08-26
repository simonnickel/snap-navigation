//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationSplitView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    @Bindable private var state: NavState

    public init(state: NavState) {
        self.state = state
    }

    public var body: some View {
        NavigationSplitView {
            List(state.items, id: \.self, selection: $state.selected) { item in
                AnyView(item.label)
            }
        } detail: {
            if let item = state.selected {
                SnapNavigationStack(
                    path: state.pathBinding(for: item),
                    root: item
                )
            } else {
                EmptyView() // TODO:
            }
        }
    }

}
