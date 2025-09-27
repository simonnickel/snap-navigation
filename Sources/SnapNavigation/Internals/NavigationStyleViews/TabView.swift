//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    internal struct TabView<NavigationProvider: SnapNavigationProvider>: View {
        
        typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
        
        @Bindable private var navigationManager: NavigationManager
        
        init(navigationManager: NavigationManager) {
            self.navigationManager = navigationManager
        }
        
        var body: some View {
            
            SwiftUI.TabView(selection: $navigationManager.selected) {
                ForEach(navigationManager.rootDestinations) { destination in
                    
                    tab(for: destination)
                    
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            
        }
        
        
        // MARK: Tab View
        
        @TabContentBuilder<NavigationProvider.Destination>
        private func tab(for destination: NavigationProvider.Destination) -> some TabContent<NavigationProvider.Destination> {
            Tab(value: destination, role: nil) {
                SnapNavigation.SceneView<NavigationProvider>(context: .selection(destination: destination))
            } label: {
                AnyView(destination.label)
            }
        }
        
    }
    
}
