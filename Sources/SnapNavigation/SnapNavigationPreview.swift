//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

#if DEBUG

public struct SnapNavigationPreview<NavigationProvider: SnapNavigationProvider, Content: View>: View {
    
    @Environment(\.openWindow) private var openWindow
	
    internal typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
    internal typealias Destination = NavigationProvider.Destination
    internal typealias Window = SnapNavigation.Window<Destination>

    private let provider: NavigationProvider
    private let windowManager: WindowManager
    private let destination: (any SnapNavigationDestination)?
    private let configuration: SnapNavigation.WindowConfiguration
    
    public init(
        provider: NavigationProvider,
        destination: (any SnapNavigationDestination)? = nil,
        configuration: SnapNavigation.WindowConfiguration = .init(shouldBuildRoute: false, style: .single)
    ) where Content == EmptyView {
        self.provider = provider
        self.windowManager = WindowManager(provider: provider)
        self.destination = destination
        self.configuration = configuration
    }
	
	public var body: some View {
        
        if let destination = destination, let translated = provider.translate(destination) {
            
            let window: Window = .window(destination: translated, configuration: configuration)
            
            SnapNavigation.WindowView(windowManager: windowManager, window: window) { _, content in
                content
            }
            
        } else {
            
            SnapNavigation.WindowView(windowManager: windowManager, window: .main) { _, content in
                content
            }
            
        }
		
	}
	
}

#endif
