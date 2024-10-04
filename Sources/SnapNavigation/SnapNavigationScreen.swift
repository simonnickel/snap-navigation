//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationScreen: Identifiable, Hashable, Equatable {
	
	var definition: SnapNavigation.ScreenDefinition<Self> { get }
	
    var label: any View { get }

    var destination: any View { get }

}

public extension SnapNavigationScreen {
	var id: Int { self.hashValue }
}

extension Array: Hashable, Identifiable where Element: SnapNavigationScreen {
	public var id: Int { hashValue }
}

extension SnapNavigation {
	
	public struct ScreenDefinition<Screen: SnapNavigationScreen> {
		
		public var title: String
		
		public typealias IconFactory = () -> Image?
		public var icon: IconFactory?
		
		public var presentationStyle: PresentationStyle
		
		public typealias DestinationFactory = (Screen) -> (any View)
		public var destination: DestinationFactory?

		public init(title: String, systemIcon: String, style: PresentationStyle = .push, destination: DestinationFactory? = nil) {
			self.title = title
			self.icon = { Image(systemName: systemIcon) }
			self.presentationStyle = style
			self.destination = destination
		}
		
		public init(title: String, icon: IconFactory?, style: PresentationStyle = .push, destination: DestinationFactory? = nil) {
			self.title = title
			self.icon = icon
			self.presentationStyle = style
			self.destination = destination
		}
		
		public var label: any View {
			Label {
				Text(title)
			} icon: {
				icon?()
			}
		}
		
	}
	
}
