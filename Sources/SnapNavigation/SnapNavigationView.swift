//
//  SnapNavigationContainer.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

public struct SnapNavigationView<Item: SnapNavigationItem>: View {

    public typealias State = SnapNavigation.State<Item>
    public typealias Path = State.Path

    private let style: SnapNavigation.Style

    private var state: Binding<State>

    public init(state: Binding<State>, style: SnapNavigation.Style) {
        self.state = state
        self.style = style
    }

    private func pathBinding(for item: Item) -> Binding<Path> {
        let stateValue = state.wrappedValue
        var path: Path = stateValue.getPath(for: item)
        // Insert item if not on top level of items. The parent will be the root of the navigation stack, see SnapNavigationView.
        if stateValue.parent(of: item) != nil {
            path.insert(item, at: 0)
        }

        return Binding<Path> {
            path
        } set: { path in
            state.wrappedValue.setPath(path, for: item)
        }
    }


    // MARK: - Body

    public var body: some View {
        switch style {
        case .tab:
            tabView
                .tabViewStyle(.tabBarOnly)

        case .sidebar:
            splitView

        case .adaptable:
            tabView
                .tabViewStyle(.sidebarAdaptable)

        case .dynamic:
            tabView // Like SnapMatchingNavigation
        }
    }


    // MARK: Tab

    @Environment(\.horizontalSizeClass) var horizontalSize

    private var tabView: some View {

        TabView(selection: state.selected) {

            ForEach(state.wrappedValue.items) { item in

                if item.items.isEmpty || horizontalSize == .compact {
                    Tab(value: item, role: nil) {
                        NavigationStack(path: pathBinding(for: item)) {
                            SnapNavigationItemDestinationScreen(item: item)
                                .navigationDestination(for: Item.self) { item in
                                    SnapNavigationItemDestinationScreen(item: item)
                                }
                        }
                    } label: {
                        AnyView(item.label)
                    }
                } else {
                    TabSection(item.title) {

                        ForEach(item.items) { subitem in
                            Tab(value: subitem, role: nil) {
                                NavigationStack(path: pathBinding(for: subitem)) {
                                    // Show the actual parent screen, the subitem is added to the path, see SnapNavigation+State
                                    SnapNavigationItemDestinationScreen(item: item)
                                        .navigationDestination(for: Item.self) { item in
                                            SnapNavigationItemDestinationScreen(item: item)
                                        }
                                }
                            } label: {
                                AnyView(subitem.label)
                            }

                        }
                    }
                }

            }

        }

    }


    // MARK: Split

    private var splitView: some View {

        NavigationSplitView {
            List(state.wrappedValue.items, id: \.self, selection: state.selected) { item in
                AnyView(item.label)
            }
        } detail: {
            NavigationStack {
                if let selection = state.selected.wrappedValue {
                    SnapNavigationItemDestinationScreen(item: selection)
                        .navigationDestination(for: Item.self) { item in
                            SnapNavigationItemDestinationScreen(item: item)
                        }
                }
            }
        }

    }
    
}
