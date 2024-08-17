//
//  SnapNavigation+Stack.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

internal struct SnapNavigationStack<Item: SnapNavigationItem>: View {

    let path: Binding<[Item]>
    let root: Item

    var body: some View {
        NavigationStack {
            SnapNavigationDestinationScreen(item: root)
                .navigationDestination(for: Item.self) { item in
                    SnapNavigationDestinationScreen(item: item)
                }
        }
    }
    
}
