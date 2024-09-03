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
			// TODO: Select different child if path is indicating its the selected one.
//			if let firstItem = path.first, selected != firstItem, item.subitems.contains(firstItem) {
//				DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//					self.selected = firstItem
//				}
//			}
        }

        @ObservationIgnored
        internal var pathBindingsForItem: [Item: Binding<Path>] = [:]

        public func pathBinding(for item: Item) -> Binding<Path> {
            if let binding = pathBindingsForItem[item] {
                return binding
            }
			
			if let parent = parent(of: item) {
				return pathBinding(for: parent)
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
