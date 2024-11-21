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
		case window(id: UUID, style: NavigationStyle, initial: InitialContent)

		/// A special case of window.
		case settings
		
		internal var style: NavigationStyle {
			switch self {
				case .main, .settings: .fallback
				case .window(_, let style, _): style
			}
		}
		
		
		// MARK: - Content
		
		/// Content types a window can be opened with.
		public enum InitialContent: Codable, Hashable {
			case destination(Destination)
			case route(to: Destination)
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
