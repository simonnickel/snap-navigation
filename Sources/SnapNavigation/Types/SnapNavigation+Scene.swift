//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigation {
	
	public indirect enum NavigationScene<Destination: SnapNavigationDestination>: Codable, Hashable {
		
		/// The main app window.
		case main
		
		/// A window.
		case window(id: UUID, style: NavigationStyle, content: Content)

		/// A special case of window.
		case settings
		
		internal var style: NavigationStyle {
			switch self {
				case .main, .settings: .fallback
				case .window(_, let style, _): style
			}
		}
		
		
		// MARK: - Content
		
		/// Content types of a window.
		public enum Content: Codable, Hashable {
			case destination(Destination)
			case route(to: Destination)
		}
		
		
		// MARK: - Initializable
		
		/// A subset of `NavigationScene` with cases that need an initial Destination.
		public enum Initializable {
			case main, settings
			
			internal var scene: NavigationScene {
				switch self {
					case .main: .main
					case .settings: .settings
				}
			}
		}
		
	}
	
}
