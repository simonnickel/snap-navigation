
import Foundation

public extension SnapNavigation {

    public struct State<Item: SnapNavigationItem> {

        public typealias Path = [Item]

        internal let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }

        public var selected: Item?

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
