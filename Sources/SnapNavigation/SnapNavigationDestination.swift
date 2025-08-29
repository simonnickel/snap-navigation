//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationDestination: Codable, Identifiable, Hashable, Equatable, Sendable {
	
	var definition: SnapNavigation.ScreenDefinition { get }
	
	
	// MARK: Definition Overrides
	
	@MainActor
    var label: any View { get }

	@MainActor
    var destination: any View { get }

}


// MARK: - Extensions

extension Array: @retroactive Identifiable where Element: SnapNavigationDestination {
    public var id: [Element.ID] { self.map(\.id) }
}


// MARK: - Destination Definition

extension SnapNavigation {
	
	public struct ScreenDefinition {
		
		public var title: String
		
		public var icon: (any Hashable)?
		
		public var presentationStyle: PresentationStyle

		public typealias Factory = @MainActor () -> (any View)
		public var destination: Factory?
		
		public init(title: String, icon: (any Hashable)?, style: PresentationStyle = .push, destination factory: Factory? = nil) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
			self.destination = factory
		}
		
	}
	
}
