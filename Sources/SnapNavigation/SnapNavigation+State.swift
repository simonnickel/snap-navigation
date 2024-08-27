//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import SwiftUI

public extension SnapNavigation {

    @MainActor
    @Observable
    public class State<Item: SnapNavigationItem> {

        public typealias Path = [Item]
        
        public var style: Style {
            didSet {
                guard style.shouldMaintainPath != oldValue.shouldMaintainPath else { return }

                if style.shouldMaintainPath {
                    if let selected {
                        pathForItem[selected] = path
                    }
                } else {
                    if let selected, let path = pathForItem[selected] {
                        self.path = path
                    }
                }
            }
        }

        public var selected: Item?

        public init(items: [Item], style: Style) {
            self.items = items
            self.style = style
            self.selected = Item.initial
        }


        // MARK: Items

        internal let items: [Item]

        public func parent(of item: Item) -> Item? {
            guard !items.contains(item) else { return nil }

            return items.first { $0.subitems.contains(item) }
        }


        // MARK: Path

        /// The path is used for navigation styles that do not maintain the path for each item (see `SnapNavigation.Style.shouldMaintainPath`).
        public var path: Path = []

        /// The Paths in pathForItem are used for navigation styles that maintain the path for each item (see `SnapNavigation.Style.shouldMaintainPath`).
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

                // Do not insert if path already has content, e.g. when `.path` is copied on style change.
                if path == [] {
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
