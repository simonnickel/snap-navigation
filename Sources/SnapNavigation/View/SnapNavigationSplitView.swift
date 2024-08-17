//
//  SnapNavigationSplitView.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 17.08.24.
//

import SwiftUI

struct SnapNavigationSplitView<Item: SnapNavigationItem>: View {

    typealias NavState = SnapNavigation.State<Item>

    let state: Binding<NavState>

    var body: some View {
        NavigationSplitView {
            List(state.wrappedValue.items, id: \.self, selection: state.selected) { item in
                AnyView(item.label)
            }
        } detail: {
            NavigationStack {
                if let selection = state.selected.wrappedValue {
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
