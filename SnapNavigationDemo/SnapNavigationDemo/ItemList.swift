//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

struct ItemList: View {

    let item: NavigationItem

    var body: some View {
        List(item.subitems) { subitem in
            NavigationLink(value: subitem) {
                AnyView(subitem.label)
            }
        }
        .navigationTitle(item.rawValue)
    }

}
