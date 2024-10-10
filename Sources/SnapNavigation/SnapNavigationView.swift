//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<NavigationProvider: SnapNavigationProvider>: View {

    public typealias NavigationState = SnapNavigation.State<NavigationProvider>

	private let state: NavigationState

    public init(provider: NavigationProvider) {
        self.state = SnapNavigation.State(provider: provider)
    }


    // MARK: - Body

    public var body: some View {

        SnapNavigationTabView(state: state)
			.modifier(SnapNavigation.ModalPresentationModifier<NavigationProvider>(level: state.modalLevelCurrent))
			.environment(state)
        
    }
    
}
