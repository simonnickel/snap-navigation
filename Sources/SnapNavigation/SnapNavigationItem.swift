//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable, Equatable {
	
	var definition: SnapNavigation.ItemDefinition<Self> { get }
	
    var label: any View { get }

    var destination: any View { get }

}

public extension SnapNavigationItem {
	var id: Int { self.hashValue }
}

extension SnapNavigation {
	
	public struct ItemDefinition<Item: SnapNavigationItem> {
		
		public var title: String
		public var systemImage: String?
		
		public typealias DestinationFactory = (Item) -> (any View)
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
