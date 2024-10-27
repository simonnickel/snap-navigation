//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationDestination: Identifiable, Hashable, Equatable, Sendable {
	
	var definition: SnapNavigation.ScreenDefinition { get }
	
	
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
	
	public struct ScreenDefinition {
		
		public var title: String
		
		public var icon: (any Hashable)?
		
		public var presentationStyle: PresentationStyle

		/// Destination Factory has to be stored as non generic to allow ScreenDefinition to be non generic. Required to have Destination enums with a different Destination type as associated value.
		public typealias Factory = @MainActor () -> (any View)
		public typealias DestinationFactory = @MainActor (any SnapNavigationDestination) -> (any View)
		public typealias DestinationFactorySpecific<Destination: SnapNavigationDestination> = @MainActor (Destination) -> (any View)
		
		public var destination: DestinationFactory? {
			if let factory {
				return { _ in
					return factory()
				}
			} else if let destinationFactory {
				return { destination in
					return destinationFactory(destination)
				}
			} else {
				return nil
			}
		}
		private var factory: Factory?
		private var destinationFactory: DestinationFactory?

		public init(title: String, icon: (any Hashable)?, style: PresentationStyle = .push) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
		}
		
		public init(title: String, icon: (any Hashable)?, style: PresentationStyle = .push, destination factory: @escaping Factory) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
			
			self.factory = factory
		}
		
		public init<Destination: SnapNavigationDestination>(title: String, icon: (any Hashable)?, style: PresentationStyle = .push, destination factory: @escaping DestinationFactorySpecific<Destination>) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
			
			self.destinationFactory = { destination in
				guard let destination = destination as? Destination else {
					return EmptyView()
				}
				return factory(destination)
			}
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
