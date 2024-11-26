//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

#if DEBUG

public struct SnapNavigationPreview<NavigationProvider: SnapNavigationProvider, Content: View>: View {
    
    @Environment(\.openWindow) private var openWindow
	
    internal typealias Destination = NavigationProvider.Destination
    internal typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
    internal typealias Window = SnapNavigation.Window<Destination>

    private let provider: NavigationProvider
    private let manager: WindowManager
    private let destination: (any SnapNavigationDestination)?
    private let configuration: SnapNavigation.WindowConfiguration
    
    public init(
        provider: NavigationProvider,
        destination: (any SnapNavigationDestination)? = nil,
        configuration: SnapNavigation.WindowConfiguration = .init(shouldBuildRoute: false, style: .single)
    ) where Content == EmptyView {
        self.provider = provider
        self.manager = WindowManager(provider: provider)
        self.destination = destination
        self.configuration = configuration
    }
	
	public var body: some View {
        
        if let destination = destination, let translated = provider.translate(destination) {
            
            let window: Window = .window(destination: translated, configuration: configuration)
            
            SnapNavigation.WindowView(manager: manager, window: window) { _, content in
                content
            }
            
        } else {
            
            SnapNavigation.WindowView(manager: manager, window: .main) { _, content in
                content
            }
            
        }
		
	}
	
}

#endif
