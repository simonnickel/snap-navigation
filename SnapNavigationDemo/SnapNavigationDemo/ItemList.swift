//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
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
