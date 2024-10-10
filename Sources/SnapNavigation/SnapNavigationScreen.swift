//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationScreen: Identifiable, Hashable, Equatable {
	
	var definition: SnapNavigation.ScreenDefinition<Self> { get }
	
	
	// MARK: Definition Overrides
	
	@MainActor
    var label: any View { get }

	@MainActor
    var destination: any View { get }

}


// MARK: - Extensions

public extension SnapNavigationScreen {
	var id: Int { self.hashValue }
}

extension Array: Hashable, Identifiable where Element: SnapNavigationScreen {
	public var id: Int { hashValue }
}


// MARK: - Screen Definition

extension SnapNavigation {
	
	public struct ScreenDefinition<Screen: SnapNavigationScreen> {
		
		public var title: String
		
		public var icon: String?
		
		public var presentationStyle: PresentationStyle
		
		public typealias DestinationFactory = @MainActor (Screen) -> (any View)
		public var destination: DestinationFactory?

		public init(title: String, icon: String?, style: PresentationStyle = .push, destination: DestinationFactory? = nil) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
			self.destination = destination
		}
		
		@MainActor
		public var label: any View {
			Label {
				Text(title)
			} icon: {
				if let icon {
					Image(systemName: icon)
				}
			}
		}
		
	}
	
}
