//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct DeeplinkButton: View {
	
	@Environment(NavigationState.self) private var navigationState

	let title: String
	let screen: Screen

	var body: some View {
		NavigationButton(title: title) {
			navigationState.navigate(to: screen)
		}
	}
}

struct PresentButton: View {
	
	@Environment(NavigationState.self) private var navigationState

	let title: String
	let screen: Screen

	var body: some View {
		NavigationButton(title: title) {
			navigationState.present(screen: screen)
		}
	}
}

struct PushButton: View {
	
	@Environment(NavigationState.self) private var navigationState

	let title: String
	let screen: Screen

	var body: some View {
		NavigationButton(title: title) {
			navigationState.push(screen: screen)
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
