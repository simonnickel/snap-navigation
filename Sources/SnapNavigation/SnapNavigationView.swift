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
        var path: Path = state.wrappedValue.getPath(for: item)

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

    private var tabView: some View {

        TabView(selection: state.selected) {

            ForEach(state.wrappedValue.items) { item in

                Tab(value: item, role: nil) {
                    NavigationStack(path: pathBinding(for: item)) {
                        SnapNavigationItemScreen(item: item)
                            .navigationDestination(for: Item.self) { item in
                                SnapNavigationItemScreen(item: item)
                            }
                    }
                } label: {
                    AnyView(item.label)
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
                    SnapNavigationItemScreen(item: selection)
                        .navigationDestination(for: Item.self) { item in
                            SnapNavigationItemScreen(item: item)
                        }
                }
            }
        }

    }
    
}
