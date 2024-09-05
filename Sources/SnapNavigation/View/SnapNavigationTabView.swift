//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

internal struct SnapNavigationTabView<ItemProvider: SnapNavigationItemProvider>: View {

	typealias NavState = SnapNavigation.State<ItemProvider>

    @Environment(\.horizontalSizeClass) private var horizontalSize

    @Bindable private var state: NavState

    init(state: NavState) {
        self.state = state
    }

	var body: some View {
		
		TabView(selection: $state.selected) {
			ForEach(state.items) { item in
				
				if shouldShowSection(for: item) {
					
					TabSection(item.definition.title) {
						ForEach(state.subitems(for: item)) { subitem in
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
	
	private func shouldShowSection(for item: ItemProvider.Item) -> Bool {
		state.subitems(for: item).isEmpty == false && horizontalSize != .compact
	}
	
	
	// MARK: Tab View
	
	@TabContentBuilder<ItemProvider.Item>
	private func tab(for item: ItemProvider.Item) -> some TabContent<ItemProvider.Item> {
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
