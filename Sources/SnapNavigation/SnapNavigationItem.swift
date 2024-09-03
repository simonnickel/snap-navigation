//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public protocol SnapNavigationItem: Identifiable, Hashable, Equatable {
	
    static var initial: Self { get }

    var subitems: [Self] { get }
	
	var path: SnapNavigation.State<Self>.Path { get }
	
	var definition: SnapNavigation.ItemDefinition { get }
	
    var label: any View { get }

    var destination: any View { get }

}

extension SnapNavigation {
	
	public struct ItemDefinition {
		
		public var title: String
		public var systemImage: String?

		public init(title: String, systemImage: String? = nil) {
			self.title = title
			self.systemImage = systemImage
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
