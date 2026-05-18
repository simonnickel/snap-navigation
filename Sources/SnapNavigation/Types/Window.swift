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
		
		/// A window opened programmatically for a specific destination.
        case window(destination: Destination, configuration: WindowConfiguration)

		/// The macOS Settings window, managed by the system as a dedicated scene.
		case settings
		
		internal var style: NavigationStyle {
			switch self {
				case .main, .settings: .automatic
                case .window(_, let configuration): configuration.style
			}
		}
		
		
		// MARK: - Initializable
		
		/// A subset of `Window` with cases that require an initial `Destination`.
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
