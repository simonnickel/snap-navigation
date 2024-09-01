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

    // TODO: Properly handle expanded state
    @State private var isExpanded: Bool = false

    public var body: some View {
        NavigationSplitView {
            List(selection: $state.selected) {
                ForEach(state.items) { item in
                    if item.subitems.isEmpty {
                        NavigationLink(value: item) {
                            AnyView(item.label)
                        }
                    } else {
                        Section(isExpanded: $isExpanded) {
                            ForEach(item.subitems) { subitem in
                                NavigationLink(value: subitem) {
                                    AnyView(subitem.label)
                                }
                            }
                        } header: {
                            Text(item.title)
                        }
                    }
                }
            }
        } detail: {
            if let item = state.selected {
                var root = item
                if let parent = state.parent(of: item) {
                    let _ = root = parent
                }

                SnapNavigationStack(
                    path: $state.path,
                    root: root
                )
            } else {
                EmptyView() // TODO:
            }
        }
        .onChange(of: state.selected ?? .initial) { oldValue, newValue in
            if let parent = state.parent(of: newValue) {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    state.path.insert(newValue, at: 0)
                }
            }
        }
    }

}
