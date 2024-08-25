//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public extension SnapNavigation {

    @MainActor
    public class State<Item: SnapNavigationItem> {

        public typealias Path = [Item]

        public init(items: [Item]) {
            self.items = items
        }


        // MARK: Items

        internal let items: [Item]

        public var selected: Item?

        public var selectedBinding: Binding<Item?> {
            Binding(get: { [weak self] in
                self?.selected
            }, set: { [weak self] value in
                self?.selected = value
            })
        }

        public func parent(of item: Item) -> Item? {
            guard !items.contains(item) else { return nil }

            return items.first { $0.items.contains(item) }
        }


        // MARK: Path

        private var pathForItem: [Item : Path] = [:]

        public func getPath(for item: Item) -> Path {
            pathForItem[item] ?? []
        }

        public func setPath(_ path: Path, for item: Item) {
            pathForItem[item] = path
        }

        private var pathBindingsForItem: [Item: Binding<Path>] = [:]

        public func pathBinding(for item: Item) -> Binding<Path> {
            if let binding = pathBindingsForItem[item] {
                return binding
            }

            // Insert item if not on top level of items. The parent will be the root of the navigation stack, see tabView.
			if let parent = parent(of: item) {
                var path: Path = getPath(for: item)
                path.insert(item, at: 0)
                setPath(path, for: item)
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
