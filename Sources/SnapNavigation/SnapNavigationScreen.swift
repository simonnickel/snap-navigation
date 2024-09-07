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
		public var systemImage: String?
		
		public typealias DestinationFactory = (Screen) -> (any View)
		public var destination: DestinationFactory?

		public init(title: String, systemImage: String? = nil, destination: DestinationFactory? = nil) {
			self.title = title
			self.systemImage = systemImage
			self.destination = destination
		}
		
		public var label: any View {
			if let systemImage = systemImage {
				return Label(title, systemImage: systemImage)
			} else {
				return Text(title)
			}
		}
		
	}
	
}
