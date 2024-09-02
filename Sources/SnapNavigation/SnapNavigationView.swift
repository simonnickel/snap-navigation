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
			.onChange(of: horizontalSize, initial: true) { oldValue, newValue in
				state.update(with: newValue)
				
                let selected = state.selected
                
                switch newValue {
                case .regular:
                    let path = state.getPath(for: selected)
						
                    if let firstPathItem = path.first {
						// Select child of the previously selected item and copy the path.
						
						guard selected == state.parent(of: firstPathItem) else { return }
						
                        state.setPath(path, for: firstPathItem)
                        
                        // Without AsyncAfter animations of the NavigationStack are broken afterwards.
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            state.selected = firstPathItem
                        }
						
					} else {
						// Select first child, reset it's path.
						
						if let firstChild = selected.subitems.first {
							state.setPath([], for: firstChild)
							state.selected = firstChild
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
