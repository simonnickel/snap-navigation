//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

struct ItemScreen: View {

    @EnvironmentObject private var appState: AppState

    @State var showConfig: Bool = false

	let item: NavigationItem
	
	var body: some View {
        NavigationLink(value: NavigationItem.infinity) {
            AnyView(NavigationItem.infinity.label)
		}
		.navigationTitle(item.rawValue)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showConfig.toggle()
                } label: {
                    Label("Label", systemImage: "slider.horizontal.3")
                }
                .popover(isPresented: $showConfig, attachmentAnchor: .point(.bottom), arrowEdge: .bottom, content: {
                    ConfigView()
                        .padding()
                        .presentationCompactAdaptation(.popover)
                })
            }
        }
	}
	
}
