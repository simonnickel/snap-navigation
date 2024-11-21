//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

#if DEBUG

public struct SnapNavigationPreview<NavigationProvider: SnapNavigationProvider, Content: View>: View {
    
    @Environment(\.openWindow) private var openWindow
	
    internal typealias WindowManager = SnapNavigation.WindowManager<NavigationProvider>
	public typealias Window = SnapNavigation.Window<NavigationProvider.Destination>

    private let manager: WindowManager
    private let window: Window
    
    public typealias ContentBuilder = () -> Content
    private let content: ContentBuilder?
	
    public init(provider: NavigationProvider, content: @escaping ContentBuilder) {
        self.manager = WindowManager(provider: provider)
        self.window = .main
        self.content = content
	}
    
    public init(provider: NavigationProvider, window: Window = .main) where Content == EmptyView {
        self.manager = WindowManager(provider: provider)
        self.window = window
        self.content = nil
    }
	
	public var body: some View {
		
        if let content {
            SnapNavigation.ContainerView(navigator: manager.navigator(for: window, supportsMultipleWindows: false, openWindow: openWindow)) { navigator in
                content()
            }
        } else {
            SnapNavigation.WindowView(manager: manager, window: window) { _, content in
                content
            }
        }
		
	}
	
}

#endif
