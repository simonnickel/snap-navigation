//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<NavigationProvider: SnapNavigationProvider>: View {

    @Environment(\.horizontalSizeClass) private var horizontalSize

    public typealias NavigationState = SnapNavigation.State<NavigationProvider>

	private let state: NavigationState

    public init(state: NavigationState) {
        self.state = state
    }


    // MARK: - Body

    public var body: some View {

        SnapNavigationTabView(state: state)
			.onChange(of: state.selected, { oldValue, newValue in
				// Only trigger navigation when subscreen got selected.
				if state.screens.contains(newValue) {
					return
				}

				#if os(iOS)
				// Without wrapping the call in Task, sometimes the stack animations will break on iPad.
				Task {
					state.navigate(to: newValue)
				}
				#else
				state.navigate(to: newValue)
				#endif
			})
			.modifier(SnapPresentationModifier<NavigationProvider>(level: state.currentModalLevel))
			.environment(state)
        
    }
    
}
