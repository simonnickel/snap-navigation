//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import SnapNavigation

struct ConfigView: View {

    @EnvironmentObject var appState: AppState

    var body: some View {
        
        Picker(selection: $appState.navigationStyle) {
            ForEach(SnapNavigation.Style.allCases, id: \.self) { style in
                Text(style.rawValue.capitalized)
            }
        } label: {
            Text("Navigation Style")
        }
        .pickerStyle(.segmented)

    }
}
