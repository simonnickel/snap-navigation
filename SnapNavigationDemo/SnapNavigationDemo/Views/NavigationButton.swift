//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SnapNavigation
import SwiftUI

struct DeeplinkButton: View {
	
	@Environment(Navigator.self) private var navigator

	let title: String
	let destination: AppDestination

	var body: some View {
		NavigationButton(title: title) {
			navigator.navigate(to: destination)
		}
	}
}

struct PresentButton: View {
	
	@Environment(Navigator.self) private var navigator

	let title: String
	let destination: AppDestination

	var body: some View {
		NavigationButton(title: title) {
			navigator.present(destination: destination, style: .modal)
		}
	}
}

struct NavigationButton: View {

	let title: String
	let action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			VStack {
				Text(title)
			}
			.bold()
			.font(.system(.caption))
			.foregroundStyle(.white)
		}
		.padding(.horizontal, 10)
		.padding(.vertical, 5)
		.background(.green, in: .rect(cornerRadius: 5))
	}
}
