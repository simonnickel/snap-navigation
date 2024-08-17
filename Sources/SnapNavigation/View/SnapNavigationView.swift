//
//  SnapNavigationView.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

public struct SnapNavigationView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    private let style: SnapNavigation.Style

    private let state: Binding<NavState>

    public init(state: Binding<NavState>, style: SnapNavigation.Style) {
        self.state = state
        self.style = style
    }


    // MARK: - Body

    public var body: some View {
        switch style {
        case .tab:
            SnapNavigationTabView(state: state)
                .tabViewStyle(.tabBarOnly)

        case .sidebar:
            SnapNavigationSplitView(state: state)

        case .adaptable:
            SnapNavigationTabView(state: state)
                .tabViewStyle(.sidebarAdaptable)

        case .dynamic:
            SnapNavigationTabView(state: state) // Like SnapMatchingNavigation
        }
    }
    
}
