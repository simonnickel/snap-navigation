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
		NavigationLink(value: NavigationItem.triangle) {
			AnyView(NavigationItem.triangle.label)
		}
		.navigationTitle(item.rawValue)
	}
	
}
