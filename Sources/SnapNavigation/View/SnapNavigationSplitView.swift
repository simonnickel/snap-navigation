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
    }

    public var body: some View {
        NavigationSplitView {
            List(state.items, id: \.self, selection: state.selectedBinding) { item in
                AnyView(item.label)
            }
        } detail: {
            NavigationStack {
                if let selection = state.selected {
                    SnapNavigationDestinationScreen(item: selection)
                        .navigationDestination(for: Item.self) { item in
                            SnapNavigationDestinationScreen(item: item)
                        }
                } else {
                    EmptyView()
                }
            }
        }
    }

}
