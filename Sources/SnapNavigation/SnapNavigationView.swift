//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public struct SnapNavigationView<NavigationProvider: SnapNavigationProvider>: View {

    public typealias Navigator = SnapNavigation.Navigator<NavigationProvider>

	private let navigator: Navigator

    public init(provider: NavigationProvider) {
        self.navigator = SnapNavigation.Navigator(provider: provider)
    }
	
    public init(navigator: Navigator) {
		self.navigator = navigator
    }


    // MARK: - Body

    public var body: some View {

        SnapNavigationTabView(navigator: navigator)
			.modifier(SnapNavigation.ModalPresentationModifier<NavigationProvider>(level: navigator.modalLevelCurrent))
			.environment(navigator)
        
    }
    
}
