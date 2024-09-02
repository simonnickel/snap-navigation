//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<Item: SnapNavigationItem>: View {

    @Environment(\.horizontalSizeClass) private var horizontalSize

    public typealias NavState = SnapNavigation.State<Item>

    private let state: NavState

    public init(state: NavState) {
        self.state = state
    }


    // MARK: - Body

    public var body: some View {

        SnapNavigationTabView(state: state)
            .tabViewStyle(.sidebarAdaptable)
            .onChange(of: horizontalSize) { oldValue, newValue in
                guard let selected = state.selected else { return }
                
                switch newValue {
                case .regular:
                    // Select child of the previously selected parent and copy the path.
                    let path = state.getPath(for: selected)
                    if let firstPathItem = path.first, selected.subitems.contains(firstPathItem) {
                        state.setPath(path, for: firstPathItem)
                        
                        // Without AsyncAfter animations of the NavigationStack are broken afterwards.
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            state.selected = firstPathItem
                        }
                    }
                    
                case .compact:
                    // Select the parent of the previously selected subitem and copy the path.
                    if let parent = state.parent(of: selected) {
                        state.setPath(state.getPath(for: selected), for: parent)
                        
                        // Without AsyncAfter animations of the NavigationStack are broken afterwards.
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            state.selected = parent
                        }
                    }
                    
                case .none, .some(_): break
                }
            }
        
    }
    
}
