//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigation {
	
	public indirect enum Window<Destination: SnapNavigationDestination>: Codable, Hashable {
		
		/// The main app window.
		case main
		
		/// A window.
        case window(id: UUID, destination: Destination, buildRoute: Bool, style: NavigationStyle)

		/// A special case of window.
		case settings
		
		internal var style: NavigationStyle {
			switch self {
				case .main, .settings: .fallback
				case .window(_, _, _, let style): style
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
