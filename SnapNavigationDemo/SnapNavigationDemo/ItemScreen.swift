//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

struct ItemScreen: View {
	
	let item: NavigationItem
	
	var body: some View {
        NavigationLink(value: NavigationItem.infinity) {
            AnyView(NavigationItem.infinity.label)
		}
		.navigationTitle(item.rawValue)
	}
	
}
