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
        internal typealias Navigator = SnapNavigation.Navigator<NavigationProvider>
        internal typealias Window = SnapNavigation.Window<NavigationProvider.Destination>
        internal typealias WindowSetupHandler = Window.WindowSetupHandler<WindowContent>
        
        private let manager: WindowManager
        private let window: Window
        private let setup: WindowSetupHandler?
        
        internal init(manager: WindowManager, window: Window, setup: WindowSetupHandler? = nil) {
            self.manager = manager
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
            
            SnapNavigation.ContainerView(navigator: manager.navigator(for: window, supportsMultipleWindows: supportsMultipleWindows, openWindow: openWindow)) { navigator in
                return Content(navigator: navigator)
            }
            
        }
        
        internal struct Content: View {
            
            @Environment(\.navigationStyle) private var navigationStyle
            
            internal let navigator: Navigator
            
            var body: some View {
                switch navigationStyle ?? navigator.window.style {
                    
                case .single:
                    SnapNavigationSingleView(navigator: navigator)
                    
                case .tabsAdaptable:
                    SnapNavigationTabView(navigator: navigator)
                    
                }
            }
        }
        
    }
    
}
