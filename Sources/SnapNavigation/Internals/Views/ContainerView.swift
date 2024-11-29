//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    internal struct ContainerView<NavigationProvider: SnapNavigationProvider, Content: View>: View {
        
        internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
        
        private let navigationManager: NavigationManager
        
        internal typealias ContentBuilder = (NavigationManager) -> Content
        private let content: ContentBuilder
        
        internal init(navigationManager: NavigationManager, content: @escaping ContentBuilder) {
            self.navigationManager = navigationManager
            self.content = content
        }
        
        internal var body: some View {
            content(navigationManager)
                .modifier(SnapNavigation.ModalPresentationModifier<NavigationProvider>(level: navigationManager.modalLevelCurrent))
                /// For internal use only.
                .environment(navigationManager)
                /// For handling navigation.
                .environment(\.navigator) { action in
                    navigationManager.handle(action: action)
                }
                .environment(\.navigationState, navigationManager.stateHash)
        }
        
    }
    
}
