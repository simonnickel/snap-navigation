//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

public extension SnapNavigation {
    
    enum Action {
        
        case navigate(to: any SnapNavigationDestination)
        
        case present(destination: any SnapNavigationDestination, style: PresentationStyle? = nil)
        
        case dismissCurrentModal
        
        case dismissModals
        
        case popCurrentToRoot
        
        // TODO: buildRoute param?
        case window(destination: any SnapNavigationDestination, buildRoute: Bool, style: NavigationStyle)
        
    }
    
}

extension SnapNavigation.Navigator {
    
    func handle(action: SnapNavigation.Action) {
        switch action {
            
            case .navigate(to: let destination):
                if let translated = provider.translate(destination) {
                    navigate(to: translated)
                }
            
            case .present(let destination, let style):
                if let translated = provider.translate(destination) {
                    present(destination: translated, style: style)
                }
            
            case .dismissCurrentModal:
                self.dismissCurrentModal()
            
            case .dismissModals:
                self.dismissModals()
            
            case .popCurrentToRoot:
                self.dismissCurrentModal()
            
            case .window(destination: let destination, buildRoute: let buildRoute, style: let style):
                if let translated = provider.translate(destination) {
                    self.window(translated, buildRoute: buildRoute, style: style)
                }
            
        }
    }
    
}
