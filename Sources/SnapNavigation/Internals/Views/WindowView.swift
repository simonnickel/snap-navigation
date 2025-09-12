//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

extension SnapNavigation.Window {
    
    public typealias WindowSetupHandler<Content: View> = (Self, AnyView) -> Content

}

extension SnapNavigation {
    
    internal struct WindowView<NavigationProvider: SnapNavigationProvider, WindowContent: View>: View {
        
        @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
        @Environment(\.openWindow) private var openWindow
        
        internal typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
        internal typealias NavigationManager = SnapNavigation.NavigationManager<NavigationProvider>
        internal typealias Destination = NavigationProvider.Destination
        internal typealias Window = SnapNavigation.Window<Destination>
        internal typealias WindowSetupHandler = Window.WindowSetupHandler<WindowContent>
        
        private let windowManager: WindowManager
        private let window: Window
        private let setup: WindowSetupHandler?
        
        internal init(windowManager: WindowManager, window: Window, setup: WindowSetupHandler? = nil) {
            self.windowManager = windowManager
            self.window = window
            self.setup = setup
        }
        
        var body: some View {
            
            if let setup {
                setup(window, AnyView(content))
            } else {
                content
            }
            
        }
        
        private var content: some View {
            
            SnapNavigation.ContainerView(navigationManager: windowManager.navigationManager(for: window, supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)) { navigationManager in
                return Content(navigationManager: navigationManager)
            }
            
        }
        
        internal struct Content: View {
            
            @Environment(\.navigationStyle) private var navigationStyle
            
            internal let navigationManager: NavigationManager
            
            var body: some View {
                switch navigationStyle ?? navigationManager.window.style {
                    
                    case .automatic, .single:
                        SnapNavigationSingleView(navigationManager: navigationManager)
                        
                    case .tabsAdaptable:
                        SnapNavigationTabView(navigationManager: navigationManager)
                    
                }
            }
        }
        
    }
    
}
