//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationSplitView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    private let state: NavState

    public init(state: NavState) {
        self.state = state
        _selected = State(initialValue: state.selected)
    }

    /// SnapNavigationSplitView would benefit of NavState being @Observable.
    /// But SnapNavigationTabView does not work properly when NavState is @Observable (navigation animations no longer appear).
    /// So as a workaround the selection state is handled here and forwarded to the State.
    @State private var selected: Item? {
        didSet {
            state.selectedBinding.wrappedValue = selected
        }
    }

    public var body: some View {
        NavigationSplitView {
            List(state.items, id: \.self, selection: $selected) { item in
                AnyView(item.label)
            }
        } detail: {
            if let item = selected {
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
