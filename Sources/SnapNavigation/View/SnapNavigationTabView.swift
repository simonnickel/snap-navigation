//
//  SnapNavigationTabView.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 17.08.24.
//

import SwiftUI

public struct SnapNavigationTabView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    @Environment(\.horizontalSizeClass) private var horizontalSize

    private let state: Binding<NavState>

    public init(state: Binding<NavState>) {
        self.state = state
    }

    public var body: some View {

        TabView(selection: state.selected) {
            ForEach(state.wrappedValue.items) { item in

                if item.items.isEmpty || horizontalSize == .compact {

                    Tab(value: item, role: nil) {
                        SnapNavigationStack(path: state.wrappedValue.pathBinding(for: item), root: item)
                    } label: {
                        AnyView(item.label)
                    }

                } else {

                    TabSection(item.title) {
                        ForEach(item.items) { subitem in

                            Tab(value: subitem, role: nil) {
                                // Put the actual parent screen at root, the subitem is added to the path.
                                SnapNavigationStack(path: state.wrappedValue.pathBinding(for: subitem), root: item)
                            } label: {
                                AnyView(subitem.label)
                            }

                        }
                    }
                    
                }

            }
        }
        .onChange(of: horizontalSize) { oldValue, newValue in
            let stateValue = state.wrappedValue
            guard let selected = stateValue.selected else { return }

            switch newValue {
                case .regular:
                    let path = stateValue.getPath(for: selected)
                    if let firstPathItem = path.first, selected.items.contains(firstPathItem) {
                        state.wrappedValue.setPath(path, for: firstPathItem)
                        state.wrappedValue.selected = firstPathItem
                    }

                case .compact:
                    if let parent = stateValue.parent(of: selected) {
                        state.wrappedValue.setPath(stateValue.getPath(for: selected), for: parent)
                        state.wrappedValue.selected = parent
                    }

                case .none, .some(_): break
            }
        }

    }
}
