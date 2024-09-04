//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ItemList: View {
	
	@Environment(SnapNavigation.State<NavigationItemProvider>.self) private var navigationState

    let item: NavigationItem

    var body: some View {
        List(navigationState.subitems(for: item)) { subitem in
            NavigationLink(value: subitem) {
                AnyView(subitem.label)
            }
        }
		.navigationTitle(item.definition.title)
    }

}
