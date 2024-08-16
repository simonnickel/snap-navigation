//
//  ItemList.swift
//  SnapNavigationDemo
//
//  Created by Simon Nickel on 16.08.24.
//

import SwiftUI

struct ItemList: View {

    let item: NavigationItem

    var body: some View {
        List(item.items) { item in
            NavigationLink(value: item) {
                AnyView(item.label)
            }
        }
        .navigationTitle(item.rawValue)
    }

}
