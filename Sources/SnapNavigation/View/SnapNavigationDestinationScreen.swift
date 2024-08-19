//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

struct SnapNavigationDestinationScreen<Item: SnapNavigationItem>: View {
	
	let item: Item
	
	var body: some View {
		AnyView(item.destination)
	}
	
}
