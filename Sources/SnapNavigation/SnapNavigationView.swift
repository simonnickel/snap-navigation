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
				if state.route(to: newValue)?.first != newValue {
					// Without wrapping the call in Task, sometimes the stack animations will break.
					Task {
						state.navigate(to: newValue)
					}
				}
			})
        
    }
    
}
