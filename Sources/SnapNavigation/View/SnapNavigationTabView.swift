//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationTabView<Item: SnapNavigationItem>: View {

    typealias NavState = SnapNavigation.State<Item>

    @Environment(\.horizontalSizeClass) private var horizontalSize

    @Bindable private var state: NavState

    init(state: NavState) {
        self.state = state
    }

	var body: some View {
		
		TabView(selection: $state.selected) {
			ForEach(state.items) { item in
				
				if shouldShowSection(for: item) {
					
					TabSection(item.title) {
						ForEach(item.subitems) { subitem in
							tab(for: subitem)
						}
					}
					
				} else {
					
					tab(for: item)
					
				}
				
			}
		}
		.tabViewStyle(.sidebarAdaptable)
		
	}
	
	private func shouldShowSection(for item: Item) -> Bool {
#if os(macOS)
		// TODO FB: Adding items to a path does not work on macOS currently.
		false
#else
		item.subitems.isEmpty == false && horizontalSize != .compact
#endif
	}
	
	
	// MARK: Tab View
	
	@TabContentBuilder<Item>
	private func tab(for item: Item) -> some TabContent<Item> {
		Tab(value: item, role: nil) {
			SnapNavigationStack(
				path: state.pathBinding(for: item),
				root: item
			)
		} label: {
			AnyView(item.label)
		}
	}
	
}
