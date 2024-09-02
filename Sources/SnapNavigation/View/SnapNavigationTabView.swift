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
				
				if item.subitems.isEmpty || state.shouldShowSubitems == false {
					
					tab(for: item, root: item)
					
				} else {
					
					TabSection(item.title) {
						ForEach(item.subitems) { subitem in
							if state.shouldAddParent {
								// Put the actual parent screen at root, the subitem is added to the path.
								tab(for: subitem, root: item)
							} else {
								tab(for: subitem, root: subitem)								
							}
						}
					}
					
				}
				
			}
		}
		.tabViewStyle(.sidebarAdaptable)
		
	}
	
	
	// MARK: Tab View
	
	@TabContentBuilder<Item>
	private func tab(for item: Item, root: Item) -> some TabContent<Item> {
		Tab(value: item, role: nil) {
			SnapNavigationStack(
				path: state.pathBinding(for: item),
				root: root
			)
		} label: {
			AnyView(item.label)
		}
	}
	
}
