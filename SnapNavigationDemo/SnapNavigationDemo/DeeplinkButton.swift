//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct DeeplinkButton: View {
	
	@Environment(SnapNavigation.State<NavigationItemProvider>.self) private var navigationState
	
	let title: String
	let item: NavigationItem

	var body: some View {
		Button {
			navigationState.navigate(to: item)
		} label: {
			Text(title)
				.font(.system(.caption))
				.bold()
				.foregroundStyle(.white)
		}
		.padding(.horizontal, 10)
		.padding(.vertical, 5)
		.background(.green, in: .capsule)
	}
}
