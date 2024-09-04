//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<ItemProvider: SnapNavigationItemProvider>: View {

    @Environment(\.horizontalSizeClass) private var horizontalSize

    public typealias NavState = SnapNavigation.State<ItemProvider>

    private let state: NavState

    public init(state: NavState) {
        self.state = state
    }


    // MARK: - Body

    public var body: some View {

        SnapNavigationTabView(state: state)
			.environment(state)
			.onChange(of: state.selected, { oldValue, newValue in
				var path = state.path(for: newValue)
				if let first = path.first {
					path.remove(at: 0)
					path.append(newValue)
					DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
						state.setPath(path, for: first)
						state.pathBindingsForItem[first] = nil
						state.selected = first
					}
				}
			})
        
    }
    
}
