//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationDestination: Identifiable, Hashable, Equatable, Sendable {
	
	var definition: SnapNavigation.ScreenDefinition<Self> { get }
	
	
	// MARK: Definition Overrides
	
	@MainActor
    var label: any View { get }

	@MainActor
    var destination: any View { get }

}


// MARK: - Extensions

extension SnapNavigationDestination {
	public var id: Int { self.hashValue }
}

extension Array: @retroactive Identifiable where Element: SnapNavigationDestination {
	public var id: Int { hashValue }
}


// MARK: - Destination Definition

extension SnapNavigation {
	
	public struct ScreenDefinition<Destination: SnapNavigationDestination> {
		
		public var title: String
		
		public var icon: (any Hashable)?
		
		public var presentationStyle: PresentationStyle
		
		public typealias DestinationFactory = @MainActor (Destination) -> (any View)
		public var destination: DestinationFactory?

		public init(title: String, icon: (any Hashable)?, style: PresentationStyle = .push, destination: DestinationFactory? = nil) {
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
				if let icon = icon as? String {
					Image(systemName: icon)
				}
			}
		}
		
	}
	
}
