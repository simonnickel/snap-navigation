//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    internal struct SingleView<NavigationProvider: SnapNavigationProvider>: View {
        
        typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
        
        private var navigationManager: NavigationManager
        
        init(navigationManager: NavigationManager) {
            self.navigationManager = navigationManager
        }
        
        var body: some View {
            
            let selection = navigationManager.selected
            SnapNavigation.SceneView<NavigationProvider>(context: .selection(destination: selection))
            
        }
        
    }
    
}
