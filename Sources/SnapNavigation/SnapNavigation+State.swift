//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

public extension SnapNavigation {

    @MainActor
    @Observable
    public class State<ItemProvider: SnapNavigationItemProvider> {

		public typealias Item = ItemProvider.Item
        public typealias Path = [Item]

		public init(itemProvider: ItemProvider) {
            self.selected = ItemProvider.initial
			self.itemProvider = itemProvider
        }

		
        // MARK: Selected

        public var selected: Item


        // MARK: Items
		
		private let itemProvider: ItemProvider
		
		public var items: [Item] {
			itemProvider.items
		}
		
		public func path(for item: Item) -> Path {
			itemProvider.path(for: item)
		}
		
		public func subitems(for item: Item) -> [Item] {
			itemProvider.subitems(for: item)
		}
		
        public func parent(of item: Item) -> Item? {
			guard !itemProvider.items.contains(item) else { return nil }

			return itemProvider.items.first { subitems(for: $0).contains(item) }
        }


        // MARK: Path

        @ObservationIgnored
        private var pathForItem: [Item : Path] = [:]

        public func getPath(for item: Item) -> Path {
            pathForItem[item] ?? []
        }

        public func setPath(_ path: Path, for item: Item) {
            pathForItem[item] = path
        }

        @ObservationIgnored
        internal var pathBindingsForItem: [Item: Binding<Path>] = [:]

        public func pathBinding(for item: Item) -> Binding<Path> {
            if let binding = pathBindingsForItem[item] {
                return binding
            }

            let binding = Binding<Path> { [weak self] in
                self?.getPath(for: item) ?? []
            } set: { [weak self] path in
                self?.setPath(path, for: item)
            }

            pathBindingsForItem[item] = binding
            return binding
        }

    }
    
}
