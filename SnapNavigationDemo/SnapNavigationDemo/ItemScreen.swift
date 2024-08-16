//
//  ItemScreen.swift
//  SnapNavigationDemo
//
//  Created by Simon Nickel on 16.08.24.
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
