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
		
		
		// MARK: Navigate
		
		public func navigate(to item: Item) {
			guard let itemLocation = route(to: item) else {
				return
			}
			var path = itemLocation
			if let first = path.first {
				path.removeFirst()
				selected = first
#if os(macOS)
				// macOS uses SplitView, where a selection in the sidebar clears the path.
				// Wrapping this in Task applies the new path after the purge.
				Task {
					self.pathForItem[first] = path
				}
#else
				pathForItem[first] = path
#endif
			}
		}


        // MARK: Items
		
		private let itemProvider: ItemProvider
		
		public var items: [Item] {
			itemProvider.items
		}
		
		public func route(to item: Item) -> Path? {
			itemProvider.route(to: item)
		}
		
		public func subitems(for item: Item) -> [Item] {
			itemProvider.subitems(for: item)
		}
		
        public func parent(of item: Item) -> Item? {
			guard !itemProvider.items.contains(item) else { return nil }

			return itemProvider.items.first { subitems(for: $0).contains(item) }
        }


        // MARK: Path

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
