//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation {
    
    internal struct DestinationScreen<Destination: SnapNavigationDestination>: View {
        
        let destination: Destination
        
        var body: some View {
            
            AnyView(destination.destination)
                .navigationTitle(destination.definition.title)
            
        }
        
    }
    
}
