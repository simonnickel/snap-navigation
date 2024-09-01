//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationTabView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    @Environment(\.horizontalSizeClass) private var horizontalSize

    @Bindable private var state: NavState

    public init(state: NavState) {
        self.state = state
    }

    public var body: some View {

        TabView(selection: $state.selected) {
            ForEach(state.items) { item in

                if item.subitems.isEmpty || horizontalSize == .compact {

                    Tab(value: item, role: nil) {
                        SnapNavigationStack(
                            path: state.pathBinding(for: item),
                            root: item
                        )
                    } label: {
                        AnyView(item.label)
                    }

                } else {

                    TabSection(item.title) {
                        ForEach(item.subitems) { subitem in

                            Tab(value: subitem, role: nil) {
                                // Put the actual parent screen at root, the subitem is added to the path.
                                SnapNavigationStack(
                                    path: state.pathBinding(for: subitem),
                                    root: item
                                )
                            } label: {
                                AnyView(subitem.label)
                            }

                        }
                    }
                    
                }

            }
        }

    }
}
