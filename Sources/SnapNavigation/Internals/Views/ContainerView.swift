//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    internal struct ContainerView<NavigationProvider: SnapNavigationProvider, Content: View>: View {
        
        internal typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
        
        private let navigator: Navigator
        private let navigatorTranslator: SnapNavigation.NavigatorTranslator
        
        internal typealias ContentBuilder = (Navigator) -> Content
        private let content: ContentBuilder
        
        internal init(navigator: Navigator, content: @escaping ContentBuilder) {
            self.navigator = navigator
            self.navigatorTranslator = navigator.translator
            self.content = content
        }
        
        internal var body: some View {
            content(navigator)
                .modifier(SnapNavigation.ModalPresentationModifier<NavigationProvider>(level: navigator.modalLevelCurrent))
                .environment(navigator)
                .environment(navigatorTranslator)
        }
        
    }
    
}
