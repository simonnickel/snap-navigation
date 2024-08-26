//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<Item: SnapNavigationItem>: View {

    public typealias NavState = SnapNavigation.State<Item>

    @StateObject private var state: NavState

    public init(state: NavState) {
        _state = StateObject(wrappedValue: state)
    }


    // MARK: - Body

    public var body: some View {
        switch state.style {
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
