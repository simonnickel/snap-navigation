//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI
import Observation

public extension SnapNavigation {

    @MainActor
    @Observable
    public class State<Item: SnapNavigationItem> {

        public typealias Path = [Item]

        public init(items: [Item]) {
            self.items = items
            self.selected = Item.initial
        }
		
		internal var shouldAddParent: Bool = false
		internal var shouldShowSubitems: Bool = false
		
		internal func update(with sizeClass: UserInterfaceSizeClass?) {
			shouldShowSubitems = sizeClass != .compact
			
#if os(macOS)
			// On macOS a SplitView is used, which does not properly work with manipulating the path.
#else
			shouldAddParent = sizeClass != .compact
#endif
		}


        // MARK: Selected

        public var selected: Item


        // MARK: Items

        internal let items: [Item]

        public func parent(of item: Item) -> Item? {
            guard !items.contains(item) else { return nil }

            return items.first { $0.subitems.contains(item) }
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
        private var pathBindingsForItem: [Item: Binding<Path>] = [:]

        public func pathBinding(for item: Item) -> Binding<Path> {
            if let binding = pathBindingsForItem[item] {
                return binding
            }

            // Insert item if not on top level of items. The parent will be the root of the navigation stack, see tabView.
			if let parent = parent(of: item) {
                var path: Path = getPath(for: item)

                // Do not insert if path already has it.
				if path.contains(item) {
                    path.insert(item, at: 0)
                    setPath(path, for: item)
                }
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
