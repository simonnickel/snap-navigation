//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

#if DEBUG

public struct SnapNavigationPreview<NavigationProvider: SnapNavigationProvider, WindowContent: View>: View {
    
    @Environment(\.openWindow) private var openWindow
	
    internal typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
    public typealias Destination = NavigationProvider.Destination
    internal typealias Window = SnapNavigation.Window<Destination>
    public typealias WindowSetupHandler = SnapNavigation.Window<Destination>.WindowSetupHandler<WindowContent>

    private let provider: NavigationProvider
    private let windowManager: WindowManager
    private let destination: (any SnapNavigationDestination)?
    private let configuration: SnapNavigation.WindowConfiguration
    private let setupWindow: WindowSetupHandler?
    
    public init(
        provider: NavigationProvider,
        destination: (any SnapNavigationDestination)? = nil,
        configuration: SnapNavigation.WindowConfiguration = .init(shouldBuildRoute: false, style: .single),
        setupWindow: @escaping WindowSetupHandler
    ) {
        self.provider = provider
        self.windowManager = WindowManager(provider: provider)
        self.destination = destination
        self.configuration = configuration
        self.setupWindow = setupWindow
    }
    
    public init(
        provider: NavigationProvider,
        destination: (any SnapNavigationDestination)? = nil,
        configuration: SnapNavigation.WindowConfiguration = .init(shouldBuildRoute: false, style: .single)
    ) where WindowContent == AnyView {
        self.provider = provider
        self.windowManager = WindowManager(provider: provider)
        self.destination = destination
        self.configuration = configuration
        self.setupWindow = nil
    }
	
	public var body: some View {
        
        if let destination = destination, let translated = provider.translate(destination) {
            
            let window: Window = .window(destination: translated, configuration: configuration)
            SnapNavigation.WindowView(windowManager: windowManager, window: window, setup: setupWindow)
            
        } else {
            
            SnapNavigation.WindowView(windowManager: windowManager, window: .main, setup: setupWindow)
            
        }
		
	}
	
}

#endif
