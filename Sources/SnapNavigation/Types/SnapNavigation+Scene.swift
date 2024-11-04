//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation

extension SnapNavigation {
	
	public indirect enum NavigationScene<NavigationProvider: SnapNavigationProvider>: Codable, Hashable {
		
		public enum Content: Codable, Hashable {
			case destination(Destination)
			case route(to: Destination)
		}
		
		public typealias Destination = NavigationProvider.Destination
		
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
	}
	
}
