//
//  SnapNavigation+State.swift
//  SnapNavigation
//
//  Created by Simon Nickel on 16.08.24.
//

import Foundation

public extension SnapNavigation {

    public struct State<Item: SnapNavigationItem> {

        public typealias Path = [Item]

        public init(items: [Item]) {
            self.items = items
        }


        // MARK: Items

        internal let items: [Item]

        public var selected: Item?

        public func parent(of item: Item) -> Item? {
            guard !items.contains(item) else { return nil }

            return items.first { $0.items.contains(item) }
        }

        // TODO: Should use parent instead
        public var isChildSelected: Bool {
            guard let selected, let parent = parent(of: selected) else { return false }
            return true
        }


        // MARK: Path

        private var pathForItem: [Item : Path] = [:]

        public func getPath(for item: Item) -> Path {
            pathForItem[item] ?? []
        }

        public mutating func setPath(_ path: Path, for item: Item) {
            guard items.contains(item) else { return }
            pathForItem[item] = path
        }
    }
    
}
