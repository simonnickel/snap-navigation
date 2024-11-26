//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigation {
    
    public struct WindowConfiguration: Codable, Hashable {
        internal let id: UUID
        public let shouldBuildRoute: Bool
        public let style: NavigationStyle
        
        public init(id: UUID = UUID(), shouldBuildRoute: Bool, style: SnapNavigation.NavigationStyle) {
            self.id = id
            self.shouldBuildRoute = shouldBuildRoute
            self.style = style
        }
    }
	
	public indirect enum Window<Destination: SnapNavigationDestination>: Codable, Hashable {
		
		/// The main app window.
		case main
		
		/// A window.
        case window(destination: Destination, configuration: WindowConfiguration)

		/// A special case of window.
		case settings
		
		internal var style: NavigationStyle {
			switch self {
				case .main, .settings: .fallback
                case .window(_, let configuration): configuration.style
			}
		}
		
		
		// MARK: - Initializable
		
		/// A subset of `NavigationWindow` with cases that need an initial Destination.
		public enum Initializable {
			case main, settings
			
			internal var window: Window {
				switch self {
					case .main: .main
					case .settings: .settings
				}
			}
		}
		
	}
	
}
