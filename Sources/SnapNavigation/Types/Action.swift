//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

extension SnapNavigation {
    
    public enum Action {
        
        case navigate(to: any SnapNavigationDestination)
        
        case present(destination: any SnapNavigationDestination, style: PresentationStyle? = nil)
        
        case dismissCurrentModal
        
        case dismissModals
        
        case popCurrentToRoot
        
        case window(destination: any SnapNavigationDestination, configuration: SnapNavigation.WindowConfiguration = .init(shouldBuildRoute: false, style: .single))
        
    }
    
}

extension SnapNavigation.Navigator {
    
    internal func handle(action: SnapNavigation.Action) {
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
                self.popCurrentToRoot()
            
            case .window(let destination, let configuration):
                if let translated = provider.translate(destination) {
                    self.window(destination: translated, configuration: configuration)
                }
            
        }
    }
    
}
