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
				// Trigger navigation when subscreen got selected.
				if state.screens.contains(newValue) {
					return
				}
				// Navigate to the screen if the selected screen is not the first on it's route.
				if let firstRouteEntry = state.route(to: newValue).first, firstRouteEntry.style == .select, firstRouteEntry.screens.first != newValue {
					// Without wrapping the call in Task, sometimes the stack animations will break.
					Task {
						state.navigate(to: newValue)
					}
				}
			})
			.modifier(SnapPresentationModifier<NavigationProvider>(entries: state.sheets))
			.environment(state)
        
    }
    
}
