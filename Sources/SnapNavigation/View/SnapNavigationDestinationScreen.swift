//
//  SnapNavigationDestinationScreen.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

struct SnapNavigationDestinationScreen<Item: SnapNavigationItem>: View {
	
	let item: Item
	
	var body: some View {
		AnyView(item.destination)
	}
	
}
